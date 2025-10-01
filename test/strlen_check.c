/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   strlen_check.c                                     :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: ohengelm <ohengelm@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/10/01 18:26:36 by ohengelm          #+#    #+#             */
/*   Updated: 2025/10/01 19:44:27 by ohengelm         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <string.h>	//strlen
#include <stdio.h>	//printf

#include "libasm.h"

static void	check(char *s);

#define C_RESET		"\033[0m"
#define C_UNDERSCR	"\033[4m"
#define C_GRAY		"\033[38;2;23;23;23m"
#define C_RED		"\033[38;2;255;0;0m"

void	strlen_check(void)
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

static void	check(char *s)
{
	int	len;
	int	ft_len;

	len = strlen(s);
	ft_len = ft_strlen(s);
	printf("s: "C_GRAY"%s"C_RESET"\n"C_UNDERSCR"len: ", s);
	if (len != ft_len)
		printf(C_RED);
	printf("%i/%i____________________________________"C_RESET"\n", ft_len, len);
}
