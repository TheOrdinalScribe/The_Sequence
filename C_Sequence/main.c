#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <time.h>
#include <signal.h>
#include <unistd.h>

#ifdef _WIN32
#include <windows.h>
#include <conio.h>
#else
#include <termios.h>
#include <sys/ioctl.h>
#endif

#include "ordinal.h"

typedef struct {
    SequenceGenerator* generator;
    int running;
    int screen_width;
    int screen_height;
} TheSequence;

static TheSequence* app = NULL;

void signal_handler(int sig) {
    if (app) {
        app->running = 0;
    }
}

void setup_signal_handlers(void) {
    signal(SIGINT, signal_handler);
    signal(SIGTERM, signal_handler);
#ifdef _WIN32
    signal(SIGBREAK, signal_handler);
#endif
}

void get_terminal_size(int* width, int* height) {
#ifdef _WIN32
    CONSOLE_SCREEN_BUFFER_INFO csbi;
    GetConsoleScreenBufferInfo(GetStdHandle(STD_OUTPUT_HANDLE), &csbi);
    *width = csbi.srWindow.Right - csbi.srWindow.Left + 1;
    *height = csbi.srWindow.Bottom - csbi.srWindow.Top + 1;
#else
    struct winsize w;
    ioctl(STDOUT_FILENO, TIOCGWINSZ, &w);
    *width = w.ws_col;
    *height = w.ws_row;
#endif
}

void clear_screen(void) {
#ifdef _WIN32
    system("cls");
#else
    system("clear");
#endif
}

void hide_cursor(void) {
#ifdef _WIN32
    CONSOLE_CURSOR_INFO cursorInfo;
    GetConsoleCursorInfo(GetStdHandle(STD_OUTPUT_HANDLE), &cursorInfo);
    cursorInfo.bVisible = FALSE;
    SetConsoleCursorInfo(GetStdHandle(STD_OUTPUT_HANDLE), &cursorInfo);
#else
    printf("\033[?25l");
    fflush(stdout);
#endif
}

void show_cursor(void) {
#ifdef _WIN32
    CONSOLE_CURSOR_INFO cursorInfo;
    GetConsoleCursorInfo(GetStdHandle(STD_OUTPUT_HANDLE), &cursorInfo);
    cursorInfo.bVisible = TRUE;
    SetConsoleCursorInfo(GetStdHandle(STD_OUTPUT_HANDLE), &cursorInfo);
#else
    printf("\033[?25h");
    fflush(stdout);
#endif
}

void set_fullscreen(void) {
#ifdef _WIN32
    HWND hwnd = GetConsoleWindow();
    SetWindowLong(hwnd, GWL_STYLE, GetWindowLong(hwnd, GWL_STYLE) & ~WS_MAXIMIZEBOX & ~WS_MINIMIZEBOX & ~WS_SYSMENU);
    ShowWindow(hwnd, SW_MAXIMIZE);
#else
    printf("\033[2J\033[H");
#endif
}

void goto_xy(int x, int y) {
#ifdef _WIN32
    COORD coord;
    coord.X = x;
    coord.Y = y;
    SetConsoleCursorPosition(GetStdHandle(STD_OUTPUT_HANDLE), coord);
#else
    printf("\033[%d;%dH", y + 1, x + 1);
#endif
}

void set_text_color_white(void) {
#ifdef _WIN32
    SetConsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE), FOREGROUND_RED | FOREGROUND_GREEN | FOREGROUND_BLUE);
#else
    printf("\033[37m");
#endif
}

void set_background_black(void) {
#ifdef _WIN32
    SetConsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE), FOREGROUND_RED | FOREGROUND_GREEN | FOREGROUND_BLUE);
#else
    printf("\033[40m");
#endif
}

void display_centered_text(const char* text, int screen_width, int screen_height) {
    int text_len = strlen(text);
    int x = (screen_width - text_len) / 2;
    int y = screen_height / 2;
    
    clear_screen();
    goto_xy(x, y);
    printf("%s", text);
    fflush(stdout);
}

void precise_sleep(double seconds) {
    struct timespec req, rem;
    req.tv_sec = (time_t)seconds;
    req.tv_nsec = (long)((seconds - req.tv_sec) * 1000000000.0);
    
    while (nanosleep(&req, &rem) == -1) {
        req = rem;
    }
}

TheSequence* sequence_create_app(void) {
    TheSequence* seq = malloc(sizeof(TheSequence));
    if (!seq) return NULL;
    
    seq->generator = sequence_create();
    if (!seq->generator) {
        free(seq);
        return NULL;
    }
    
    seq->running = 1;
    get_terminal_size(&seq->screen_width, &seq->screen_height);
    
    return seq;
}

void sequence_destroy_app(TheSequence* seq) {
    if (seq) {
        if (seq->generator) {
            sequence_destroy(seq->generator);
        }
        free(seq);
    }
}

void sequence_setup_display(TheSequence* seq) {
    set_fullscreen();
    hide_cursor();
    set_background_black();
    set_text_color_white();
    clear_screen();
}

void sequence_cleanup_display(void) {
    show_cursor();
    clear_screen();
}

void sequence_update_display(TheSequence* seq) {
    OrdinalNumber current = sequence_current(seq->generator);
    char* ordinal_str = ordinal_to_string(&current);
    display_centered_text(ordinal_str, seq->screen_width, seq->screen_height);
}

void sequence_run(TheSequence* seq) {
    const double pi = M_PI;
    
    sequence_setup_display(seq);
    sequence_update_display(seq);
    
    while (seq->running) {
        precise_sleep(pi);
        
        if (!seq->running) break;
        
        sequence_next(seq->generator);
        sequence_update_display(seq);
    }
    
    sequence_cleanup_display();
}

int main(void) {
    app = sequence_create_app();
    if (!app) {
        fprintf(stderr, "Failed to create The Sequence\n");
        return 1;
    }
    
    setup_signal_handlers();
    
    sequence_run(app);
    
    sequence_destroy_app(app);
    app = NULL;
    
    return 0;
}