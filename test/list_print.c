/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   list_print.c                                       :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: ohengelm <ohengelm@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/09/26 16:19:59 by ohengelm          #+#    #+#             */
/*   Updated: 2025/09/26 17:17:48 by ohengelm         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <stdio.h>	// printf

#include "libasm.h"

void	list_print(t_list *list)
{
	printf("%s\n", ((char [81]){[0 ...79] = '-', [80] = '\0'}));
	while (list != NULL)
	{
		if (*(int *)list->data > 11)
			printf ("%12s", (char *)list->data);
		else
			printf ("%12i", *(int *)list->data);
		list = list->next;
	}
	printf("\n%s\n", ((char [81]){[0 ...79] = '-', [80] = '\0'}));
}
