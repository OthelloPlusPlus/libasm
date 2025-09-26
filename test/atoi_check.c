/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   atoi_check.c                                       :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: ohengelm <ohengelm@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/09/18 16:26:06 by ohengelm          #+#    #+#             */
/*   Updated: 2025/09/26 17:31:35 by ohengelm         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <stdio.h> //printf
#include <errno.h> //errno

#include "libasm.h"

#define C_RESET		"\033[0m"
#define C_BOLD		"\033[1m"
#define C_UNDERSCR	"\033[4m"
#define C_RED		"\033[38;2;255;0;0m"
#define C_ORANGE	"\033[38;2;255;165;0m"
#define C_GRAY	"\033[38;2;23;23;23m"
#define C_OVERSCR	"\033[53m"

#define BORDER_LINE "-----------------------------------"

static void	call_ft_atoi_base_for(const char *a, const char *base);
static void	test_base10(void);
static void	test_bases(void);
static void	test_error(void);

void	atoi_check(void)
{
	printf(C_ORANGE C_BOLD BORDER_LINE"= Base10 ="BORDER_LINE C_RESET"\n");
	printf(C_UNDERSCR C_GRAY"[%16s]%23s : %11s"C_RESET"\n", "base", "a", "i");
	test_base10();
	printf(C_ORANGE C_BOLD BORDER_LINE"= Bases ="BORDER_LINE C_RESET"\n");
	printf(C_UNDERSCR C_GRAY"[%16s]%23s : %11s"C_RESET"\n", "base", "a", "i");
	test_bases();
	printf(C_ORANGE C_BOLD BORDER_LINE"= Error ="BORDER_LINE C_RESET"\n");
	printf(C_UNDERSCR C_GRAY"[%16s]%23s : %11s"C_RESET"\n", "base", "a", "i");
	test_error();
	return ;
}

static void	test_base10(void)
{
	call_ft_atoi_base_for("1234", "0123456789");
	call_ft_atoi_base_for("1", "0123456789");
	call_ft_atoi_base_for("0", "0123456789");
	call_ft_atoi_base_for("-0", "0123456789");
	call_ft_atoi_base_for("-1", "0123456789");
	call_ft_atoi_base_for("00100", "0123456789");
	call_ft_atoi_base_for("1234567890", "0123456789");
	call_ft_atoi_base_for("-2147483648", "0123456789");
	call_ft_atoi_base_for("2147483647", "0123456789");
	call_ft_atoi_base_for("        1234", "0123456789");
	call_ft_atoi_base_for("\t 1234", "0123456789");
	call_ft_atoi_base_for("\t\v\n\f\r 1234", "0123456789");
	call_ft_atoi_base_for("+1234", "0123456789");
	call_ft_atoi_base_for("-1234", "0123456789");
	call_ft_atoi_base_for("++1234", "0123456789");
	call_ft_atoi_base_for("+-1234", "0123456789");
	call_ft_atoi_base_for("-+1234", "0123456789");
	call_ft_atoi_base_for("--1234", "0123456789");
}

static void	test_bases(void)
{
	call_ft_atoi_base_for("110100111", "10");
	call_ft_atoi_base_for("110100111", "01");
	call_ft_atoi_base_for("000012213", "0123");
	call_ft_atoi_base_for("000000647", "01234567");
	call_ft_atoi_base_for("0000001A7", "0123456789ABCDEF");
	call_ft_atoi_base_for("-2E42G9", "OI2E4SG7B9");
}

static void	test_error(void)
{
	call_ft_atoi_base_for("", "0123456789");
	call_ft_atoi_base_for("234269", "");
	call_ft_atoi_base_for("", "");
	call_ft_atoi_base_for(NULL, "0123456789");
	call_ft_atoi_base_for("234269", NULL);
	call_ft_atoi_base_for(NULL, NULL);
	call_ft_atoi_base_for("2147483648", "0123456789");
	call_ft_atoi_base_for("-2147483649", "0123456789");
	call_ft_atoi_base_for("9999999999", "0123456789");
	call_ft_atoi_base_for("-9999999999", "0123456789");
	call_ft_atoi_base_for(" 9223372036854775807", "0123456789");
	call_ft_atoi_base_for(" 9223372036854775808", "0123456789");
	call_ft_atoi_base_for("-9223372036854775808", "0123456789");
	call_ft_atoi_base_for("-9223372036854775809", "0123456789");
	call_ft_atoi_base_for("-234269", "OI2E4SG7B9");
}

static void	call_ft_atoi_base_for(const char *a, const char *base)
{
	int	i;

	i = ft_atoi_base(a, base);
	printf("[%16s]%23s : %11i", base, a, i);
	if (errno)
		printf("  errno["C_RED"%i"C_RESET"]", errno);
	printf("\n");
	errno = 0;
}
