/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   strdup_check.c                                     :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: ohengelm <ohengelm@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/10/01 19:15:01 by ohengelm          #+#    #+#             */
/*   Updated: 2025/10/01 19:44:37 by ohengelm         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <stdio.h>	//prinf
#include <string.h>	//strcmp
#include <stdlib.h>	//free

#include "libasm.h"

#define C_RESET		"\033[0m"
#define C_UNDERSCR	"\033[4m"
#define C_GRAY		"\033[38;2;23;23;23m"
#define C_RED		"\033[38;2;255;0;0m"

static void	check(char *src);

void	strdup_check(void)
{
	check("");
	check("lorem");
	check("Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean \
commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magn\
is dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies \
nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Don\
ec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo\
, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede\
 mollis pretium. Integer tincidunt. Cras dapibus.");
}

static void	check(char *src)
{
	char	*dup;
	
	dup = ft_strdup(src);
	printf("%p "C_GRAY"%s"C_RESET"\n", src, src);
	if (src == dup)
		printf(C_RED"%p"C_RESET, dup);
	else
		printf("%p", dup);
	if (strcmp(src, dup))
		printf(" "C_RED"%s", dup);
	else
		printf(" "C_GRAY"%s", dup);
	printf(C_UNDERSCR"\n__________________________________________"C_RESET"\n");
	if (dup)
		free(dup);
}
