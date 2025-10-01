/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   main.c                                             :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: ohengelm <ohengelm@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/09/06 18:19:40 by ohengelm          #+#    #+#             */
/*   Updated: 2025/10/01 19:45:25 by ohengelm         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <stdlib.h> // srand
#include <stdio.h>	// printf
#include <time.h>	// time

void		check_asm_man_in_c_by_copying_file(void);
void		chech_asm_man_in_asm_by_echoing_stdin(void);
void		list_check(void);
void		atoi_check(void);
void		strlen_check(void);
void		strcpy_check(void);
void		strcmp_check(void);
void		strdup_check(void);

static void	print_header(char *header);

#define C_RESET		"\033[0m"
#define C_BOLD		"\033[1m"
#define C_UNDERSCR	"\033[4m"
#define C_RED		"\033[38;2;255;0;0m"
#define C_ORANGE	"\033[38;2;255;165;0m"
#define C_GRAY		"\033[38;2;23;23;23m"
#define C_OVERSCR	"\033[53m"

#define BORDER_LINE "---------------------------"

int	main(void)
{
	srand(time(NULL));

	print_header("Mandatory - strlen");
	strlen_check();
	print_header("Mandatory - strcpy");
	strcpy_check();
	print_header("Mandatory - strcmp");
	strcmp_check();
	print_header("Mandatory - strdup");
	strdup_check();
	print_header("Mandatory - copy file");
	check_asm_man_in_c_by_copying_file();
	print_header("Mandatory - echo stdin");
	chech_asm_man_in_asm_by_echoing_stdin();
	print_header("Bonus - atio");
	atoi_check();
	print_header("Bonus - list");
	list_check();

	return (0);
}

static void	print_header(char *header)
{
	printf(C_ORANGE C_BOLD BORDER_LINE"= %s ="BORDER_LINE C_RESET"\n", header);
}
