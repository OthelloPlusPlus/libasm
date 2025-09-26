/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   check_asm_man_in_c_by_copying_file.c               :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: ohengelm <ohengelm@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/09/11 19:25:07 by ohengelm          #+#    #+#             */
/*   Updated: 2025/09/26 18:39:26 by ohengelm         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <fcntl.h>	//open
#include <stdlib.h> //rand srand free
#include <stdio.h>	//dprintf
#include <errno.h>	//errno
#include <unistd.h>	//close
#include <string.h>	//memset

#include "libasm.h"

static int	copy_file_to(const char *src, const char *dst);
static int	open_file(const char *file, int oflag, int permis);
static void	copy_file_using_libasm(int fdin, int fdout);

void	check_asm_man_in_c_by_copying_file(void)
{
	int	retval;

	retval = copy_file_to("lorem", "./Output.md");
	if (retval)
		dprintf(2, "asm gave errno: %i", retval);
}

static int	copy_file_to(const char *src, const char *dst)
{
	int	fdin;
	int	fdout;

	fdin = open_file(src, O_RDONLY, 0);
	fdout = open_file(dst, O_WRONLY | O_CREAT | O_TRUNC, 0644);
	if (fdin > 2 && fdout > 2)
		printf("Copying %s into %s.\n", src, dst);
	else
		return (-1);
	copy_file_using_libasm(fdin, fdout);
	close(fdin);
	close(fdout);
	return (errno);
}

static int	open_file(const char *file, int oflag, int permis)
{
	int	fd;

	if (permis)
		fd = open(file, oflag, permis);
	else
		fd = open(file, oflag);
	if (fd < 2 || errno)
	{
		dprintf(2, "open %s failed\nfd:\t %i, errno:\t %i\n", file, fd, errno);
		exit(errno);
	}
	return (fd);
}

static void	copy_file_using_libasm(int fdin, int fdout)
{
	void	*ptr;
	char	buffer[9192];
	long	count;

	memset(buffer, 0, 9192);
	count = rand() % 9192;
	while (ft_read(fdin, buffer, count))
	{
		ptr = ft_strdup(buffer);
		if (ft_strcmp(ptr, buffer))
			dprintf(2, "Bad strcmp");
		ft_write(fdout, ptr, ft_strlen(ptr));
		if (errno)
			dprintf(2, "ft_write errno: %i", errno);
		free(ptr);
		memset(buffer, 0, count);
		count = rand() % 9192;
	}
}
