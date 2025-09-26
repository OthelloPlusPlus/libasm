/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   list_check.c                                       :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: ohengelm <ohengelm@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/09/12 18:05:54 by ohengelm          #+#    #+#             */
/*   Updated: 2025/09/26 17:17:04 by ohengelm         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <stdlib.h>	// rand
#include <stdio.h>	// printf
#include <limits.h>	// INT_MAX

#include "libasm.h"

t_list			*list_create(int size);
void			list_print(t_list *list);
void			list_check_error(t_list *list);

static int		get_diff(t_list *list1, t_list *list2);
static int		data_equals(t_list *list, void *data);
static void		remove_random_value(t_list **list);
static int		data_less_than(t_list *list, void *data);

void	list_check(void)
{
	t_list	*list;

	list = list_create(10);
	list_print(list);
	list_check_error(list);
	list_print(list);
	printf("List size: %i\n", ft_list_size(list));
	remove_random_value(&list);
	printf("List size: %i\n", ft_list_size(list));
	list_print(list);
	printf("Sorting...\n");
	ft_list_sort(&list, &get_diff);
	list_print(list);
	printf("Removing all...\n");
	ft_list_remove_if(&list, &(int){INT_MAX}, data_less_than);
	list_print(list);
	printf("list: %p (%i)\n", list, ft_list_size(list));
}

static int	get_diff(t_list *list1, t_list *list2)
{
	return (*(int *)list1->data - *(int *)list2->data);
}

static int	data_equals(t_list *list, void *data)
{
	return (*(int *)list->data == *(int *)data);
}

static int	data_less_than(t_list *list, void *data)
{
	return (*(int *)list->data < *(int *)data);
}

static void	remove_random_value(t_list **list)
{
	int	value;

	value = rand() % 12;
	printf("Removing data value: %i\n", value);
	ft_list_remove_if(list, &value, data_equals);
	ft_write(1, "Removing string: dolor\n", 23);
	ft_list_remove_if(list, "dolor", data_equals);
	ft_write(1, "Removing negatives\n", 19);
	value = 0;
	ft_list_remove_if(list, &value, data_less_than);
}
