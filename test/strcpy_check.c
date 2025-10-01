/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   strcpy_check.c                                     :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: ohengelm <ohengelm@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/10/01 18:37:25 by ohengelm          #+#    #+#             */
/*   Updated: 2025/10/01 19:43:47 by ohengelm         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <string.h>	//memset	strcmp	strlen
#include <stdio.h>	//printf

#include "libasm.h"

static void	check(char *s);
static void	print_buffer_while_comparing(char *src, char *buffer);

#define C_RESET		"\033[0m"
#define C_UNDERSCR	"\033[4m"
#define C_GRAY		"\033[38;2;23;23;23m"
#define C_RED		"\033[38;2;255;0;0m"

void	strcpy_check(void)
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
	char	buffer[4096];
	void	*ret;

	memset(buffer, 0, 4096);
	ret = ft_strcpy(buffer, src);
	printf("src %p "C_GRAY"%s\n", src, src);
	print_buffer_while_comparing(src, buffer);
	printf(C_RESET"\n"C_UNDERSCR);
	if (ret != buffer)
		printf("ret "C_RED"%p________________________________"C_RESET"\n", ret);
	else
		printf("ret %p________________________________"C_RESET"\n", ret);
}

static void	print_buffer_while_comparing(char *src, char *buffer)
{
	int		i;
	int		size;

	printf(C_RESET"buf %p "C_GRAY, buffer);
	if (src && strcmp(src, buffer))
	{
		size = strlen(src);
		i = 0;
		while (i < size)
		{
			if (buffer[i] == src[i])
				printf("%c", buffer[i]);
			else
				printf(C_RED"%c"C_GRAY, buffer[i]);
			++i;
		}
	}
	else
		i = printf("%s", buffer);
	while (i < 4096)
	{
		if (buffer[i])
			printf(C_RED"%c", buffer[i]);
		++i;
	}
}
