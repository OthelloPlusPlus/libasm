/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   print_calling_convention.c                         :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: ohengelm <ohengelm@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/09/06 20:03:25 by ohengelm          #+#    #+#             */
/*   Updated: 2025/10/01 15:37:40 by ohengelm         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <stdio.h>	//printf

// First 6 arguments (RDI-R9) are passed using 64bit registers
// Further  arguments (RSP0x10-RSP0x20) are passed using the stack (RSP)
int	print_calling_convention(void *RDI, void *RSI, void *RDX, void *RCX,\
	void *R8, void *R9, void *RSP0x10, void *RSP0x18, void *RSP0x20)
{
	printf("%p\t\"%s\"\n", RDI, (char *)RDI);
	printf("%p\t\"%s\"\n", RSI, (char *)RSI);
	printf("%p\t\"%s\"\n", RDX, (char *)RDX);
	printf("%p\t\"%s\"\n", RCX, (char *)RCX);
	printf("%p\t\"%s\"\n", R8, (char *)R8);
	printf("%p\t\"%s\"\n", R9, (char *)R9);
	printf("%p\t\"%s\"\n", RSP0x10, (char *)RSP0x10);
	printf("%p\t\"%s\"\n", RSP0x18, (char *)RSP0x18);
	printf("%p\t\"%s\"\n", RSP0x20, (char *)RSP0x20);
	return (42);
}
