/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   main.c                                             :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: ohengelm <ohengelm@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/09/06 18:19:40 by ohengelm          #+#    #+#             */
/*   Updated: 2025/09/26 17:53:41 by ohengelm         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <stdlib.h> // srand
#include <stdio.h>	// printf
#include <time.h>	// time

void	check_asm_man_in_c_by_copying_file(void);
void	chech_asm_man_in_asm_by_echoing_stdin(void);
void	list_check(void);
void	atoi_check(void);

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
	printf(C_ORANGE C_BOLD BORDER_LINE"= Mandatory - copy file ="\
BORDER_LINE C_RESET"\n");
	check_asm_man_in_c_by_copying_file();
	printf(C_ORANGE C_BOLD BORDER_LINE"= Mandatory - echo stdin ="\
BORDER_LINE C_RESET"\n");
	chech_asm_man_in_asm_by_echoing_stdin();
	printf(C_ORANGE C_BOLD BORDER_LINE"= Bonus - atio ="\
BORDER_LINE C_RESET"\n");
	atoi_check();
	printf(C_ORANGE C_BOLD BORDER_LINE"= Bonus - list ="\
BORDER_LINE C_RESET"\n");
	list_check();
	return (0);
}
