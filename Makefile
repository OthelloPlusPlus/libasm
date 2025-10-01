# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: ohengelm <ohengelm@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/09/26 18:28:57 by ohengelm          #+#    #+#              #
#    Updated: 2025/10/01 19:22:24 by ohengelm         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

NAME:=libasm.a
EXEC:=Test.out

# Object Compilarion Flags
CC:=nasm
AFLAGS:=-f elf64
CFLAGS:=-Wall -Werror

# Archive creation flags
AR:=ar
ARFLAGS:= -cr # create and insert

# Archive Files
SRC=	$(FILE_MAN:%.asm=		$(SRC_DIR)%.asm)\
		$(FILE_BONUS:%.asm=		$(SRC_DIR)%.asm)\
		$(FILE_EXTRA:%.asm=		$(SRC_DIR)%.asm)
OBJ_DIR:=	obj/
OBJ=	$(SRC:$(SRC_DIR)%.asm=	$(OBJ_DIR)%.o)

SRC_DIR:=	src/
FILE_MAN:=	ft_strlen.asm		ft_strcpy.asm			ft_strcmp.asm\
			ft_write.asm		ft_read.asm				ft_strdup.asm
FILE_BONUS:=	ft_atoi_base.asm\
				ft_list_push_front.asm	ft_list_sort.asm	ft_list_size.asm\
				ft_list_remove_if.asm
FILE_EXTRA:=	ft_print_registers.asm

# Demo Files
DEMO_DIR:=	demo/
OBJ_DEMO=	$(AOBJ_DEMO)	$(COBJ_DEMO)

ASRC_DEMO=	$(AFILE_DEMO:%.asm=				$(DEMO_DIR)%.asm)
AOBJ_DEMO=	$(ASRC_DEMO:$(DEMO_DIR)%.asm=	$(OBJ_DIR)%.o)
AFILE_DEMO:=	_start.asm	_main.asm\
				DemonstrateCallingConvention.asm

CSRC_DEMO=	$(CFILE_DEMO:%.c=			$(DEMO_DIR)%.c)
COBJ_DEMO=	$(CSRC_DEMO:$(DEMO_DIR)%.c=	$(OBJ_DIR)%.o)
CFILE_DEMO:=	print_calling_convention.c

# Test Files
TEST_DIR:=	test/

CFILE_TEST:=	main.c	check_asm_man_in_c_by_copying_file.c	atoi_check.c\
				strlen_check.c	strcpy_check.c	strcmp_check.c	strdup_check.c\
				list_check.c	list_check_error.c	list_create.c	list_print.c
CSRC_TEST=		$(CFILE_TEST:%.c=	$(TEST_DIR)%.c)

AFILE_TEST:=	chech_asm_man_in_asm_by_echoing_stdin.asm
ASRC_TEST=		$(AFILE_TEST:%.asm=	$(TEST_DIR)%.asm)
AOBJ_TEST=		$(ASRC_TEST:$(TEST_DIR)%.asm=	$(OBJ_DIR)%.o)

all: $(NAME)

$(NAME): $(OBJ_DIR) $(OBJ)
	@${AR} ${ARFLAGS} ${NAME} ${OBJ}

display:
	@printf	"%s:\n"	"$(NAME)"
	@${AR} -t ${NAME}

$(OBJ_DIR)%.o: $(SRC_DIR)%.asm
	@$(CC) $(AFLAGS) $(CFLAGS) $< -o $@

test: $(NAME) $(AOBJ_TEST)
	@gcc -I inc \
		$(CSRC_TEST) $(AOBJ_TEST)\
		$(CFLAGS) \
		-L . -l${NAME:lib%.a=%} -lm \
		-o $(EXEC)

$(OBJ_DIR):
	@mkdir $(OBJ_DIR)

$(OBJ_DIR)%.o: $(TEST_DIR)%.asm
	@printf	"Compiling %s...\n"	$@
	@$(CC) $(AFLAGS) $(CFLAGS) $< -o $@


demo: $(OBJ_DIR) $(AOBJ_DEMO) $(COBJ_DEMO)
	@printf	"Linking executable %s...\n"	"$(EXEC)"
	@ld	$(OBJ_DEMO) \
		-lc --dynamic-linker /lib64/ld-linux-x86-64.so.2 \
		-o $(EXEC)

$(OBJ_DIR)%.o: $(DEMO_DIR)%.asm
	@printf	"Compiling %s...\n"	$@
	@$(CC) $(AFLAGS) $(CFLAGS) $< -o $@

$(OBJ_DIR)%.o: $(DEMO_DIR)%.c
	@printf	"Compiling %s...\n"	$@
	@gcc $(CFLAGS) -c $< -o $@

run:
	@./$(EXEC)

clean:
	@rm -f $(OBJ) $(OBJ_DEMO) $(AOBJ_TEST) Output.md

fclean: clean
	@rm -f $(NAME) $(EXEC)
	@rmdir --ignore-fail-on-non-empty $(OBJ_DIR)

re: clean all

.PHONY: all display test demo run clean fclean re

# Display disassembled object code in Intel syntax
# objdump -d -M intel [objectFile.o]

# Convert C source into GNU assembler (GAS) syntax with Intel instructions
# Note: output is GAS syntax, not NASM-compatible
# gcc -S -masm=intel -m64 -O0 -fomit-frame-pointer [sourceFile.c]
