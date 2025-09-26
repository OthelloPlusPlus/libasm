/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   list_create.c                                      :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: ohengelm <ohengelm@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/09/26 15:45:21 by ohengelm          #+#    #+#             */
/*   Updated: 2025/09/26 17:18:07 by ohengelm         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <stdlib.h>	// calloc, rand, NULL

#include "libasm.h"

static t_list	*new_node(void);
static t_list	*add_data(t_list *node);
static char		*add_data_string(void);
static int		*add_data_int(void);

t_list	*list_create(int size)
{
	t_list	*new_list;

	new_list = NULL;
	while (size > 0)
	{
		ft_list_push_front(&new_list, new_node());
		--size;
	}
	return (new_list);
}

static t_list	*new_node(void)
{
	t_list	*node;

	node = calloc(sizeof(t_list), 1);
	node = add_data(node);
	return (node);
}

static t_list	*add_data(t_list *node)
{
	int	randomvalue;

	randomvalue = rand() % 11;
	if (randomvalue == 0)
		node->data = NULL;
	if (randomvalue < 5)
		node->data = add_data_string();
	else
		node->data = add_data_int();
	if (!node->data)
	{
		free(node);
		node = NULL;
	}
	return (node);
}

static char	*add_data_string(void)
{
	int	randomvalue;

	randomvalue = rand() % 10;
	if (randomvalue < 1)
		return (ft_strdup("lorem"));
	if (randomvalue < 2)
		return (ft_strdup("ipsum"));
	if (randomvalue < 3)
		return (ft_strdup("dolor"));
	if (randomvalue < 4)
		return (ft_strdup("sit"));
	if (randomvalue < 5)
		return (ft_strdup("amet"));
	if (randomvalue < 6)
		return (ft_strdup("consectetur"));
	if (randomvalue < 7)
		return (ft_strdup("adipiscing"));
	if (randomvalue < 8)
		return (ft_strdup("elit"));
	if (randomvalue < 9)
		return (ft_strdup("sed"));
	return (ft_strdup("do"));
}

static int	*add_data_int(void)
{
	int	*data;

	data = calloc(sizeof(int *), 1);
	if (data)
		*data = rand() % 23 - 11;
	return (data);
}
