/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   list_check_error.c                                 :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: ohengelm <ohengelm@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/09/26 16:48:17 by ohengelm          #+#    #+#             */
/*   Updated: 2025/09/26 17:05:55 by ohengelm         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <stddef.h> //null
#include <stdio.h> //dprintf

#include "libasm.h"

static int	data_equals(t_list *list, void *data);
static int	get_diff(t_list *list1, t_list *list2);

void	list_check_error(t_list *list)
{
	printf("Errorcheck: ft_list_push_front...\n");
	ft_list_push_front(NULL, NULL);
	ft_list_push_front(&list, NULL);
	ft_list_push_front(NULL, (t_list *)1);
	printf("Errorcheck: ft_list_size(NULL) == %i\n", ft_list_size(NULL));
	printf("Errorcheck: ft_list_sort...\n");
	ft_list_sort(NULL, NULL);
	ft_list_sort(&list, NULL);
	ft_list_sort(NULL, data_equals);
	printf("Errorcheck: ft_list_remove_if...\n");
	ft_list_remove_if(NULL, NULL, NULL);
	ft_list_remove_if(&list, NULL, NULL);
	ft_list_remove_if(NULL, "lorem", NULL);
	ft_list_remove_if(NULL, NULL, get_diff);
	ft_list_remove_if(&list, "lorem", NULL);
	ft_list_remove_if(&list, NULL, get_diff);
	ft_list_remove_if(NULL, "lorem", get_diff);
	printf("Errorcheck done. Should not have segfaulted or changed the list\n");
}

static int	get_diff(t_list *list1, t_list *list2)
{
	return (*(int *)list1->data - *(int *)list2->data);
}

static int	data_equals(t_list *list, void *data)
{
	return (*(int *)list->data == *(int *)data);
}
