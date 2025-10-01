/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   strcmp_check.c                                     :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: ohengelm <ohengelm@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/10/01 17:46:38 by ohengelm          #+#    #+#             */
/*   Updated: 2025/10/01 19:43:57 by ohengelm         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <string.h>	//strcmp
#include <stdio.h>	//printf

#include "libasm.h"

static void	compare(char *s1, char *s2);

#define C_RESET		"\033[0m"
#define C_UNDERSCR	"\033[4m"
#define C_GRAY		"\033[38;2;23;23;23m"
#define C_RED		"\033[38;2;255;0;0m"

void	strcmp_check(void)
{
	compare(NULL, NULL);
	compare("", NULL);
	compare("lorem", NULL);
	compare(NULL, "");
	compare("", "");
	compare("lorem", "");
	compare(NULL, "ipsum");
	compare("", "ipsum");
	compare("lorem", "ipsum");
	compare("lorem", "lorem");
	compare("lorem", "loRem");
	compare("loRem", "lorem");
	compare("Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean \
commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magn\
is dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies \
nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Don\
ec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo\
, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede\
 mollis pretium. Integer tincidunt. Cras dapibus.", \
"Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean \
commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magn\
is dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies \
nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Don\
ec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo\
, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede\
 mollis pretium. Integer tincidunt. Cras dapibus.");
}

static void	compare(char *s1, char *s2)
{
	printf("s1: "C_GRAY"%s"C_RESET"\ns2: "C_GRAY"%s"C_RESET"\n", s1, s2);
	printf("ft_: %5i\n"C_UNDERSCR"ofc: ", ft_strcmp(s1, s2));
	if (s1 && s2)
		printf("%5i", strcmp(s1, s2));
	else
		printf(""C_RED"undef");
	printf(C_RESET"________________________________________________________\n");
}
