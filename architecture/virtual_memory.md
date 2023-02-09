The virtual memory is a system to give program a controlled and isolated space, while managing access the the physical memory.

For instance, when declaring a variable in user-space, it will be allocated within this virtual memory.
```c
int x = 42;  // The variable isn't directly stored in RAM.
```

Low-Level Langages like C or even assembly doesn't manage physical by their own but an interface. It brings some benefits such as allowing more memory than the computer limit, or give a restricted area of each process.

The size of this memory depends on the architecture of the machine:

- `32` bits can handle `4` GB of virtual memory  ( `0x0` --> `0xFFFF_FFFF` )
- `64` bits can handle `256` TB of virtual memory ( `0x0` -->  `0xFFFF_FFFF_FFFF` )

When the physical memory is saturated, the data will be forwarded to an other system peripheral such as the disk, with swapping at the cost of reading and writing speed.

When the processus need to store a value, it gets written within a page dedicated to the program.

The `Memory Managment Unit`  integrated within the cpu has the role to translate the physical memory address to virtual memory. This can happen in 2 ways:

> `Segmentation` 

The virtual memory is cut into segments. In order to managed then, an `id` (selector) and a offset is stored. For a `x86` architecture, the memory would be cut into `2^16` segment of `2^32` bits each. 

The logical adress is given by the cpu, an is referenced by a global descriptor table. A limit check is applied to ensure the limit is respected, or throw an interupt otherwise. A simple addition is needed to translate the logical address to it's physical equivalent.

Segments also allow for features such as variable block size, access managment and share segment between processes (such as code for shared programs, while data would be isolated).

The main issue of this system is the creation of external fragment of lost memory that cannot be allocated.

- `Pagination` 

The pagination, consist of creating fix memory sizes that are handled by the operating system by himself, often beeing 4KB long. As the virtual memory can be way bigger than te physical, one, they can be more frames than the memory itself, but each frame will point to a page. It will also use a page selector and an offset, similar to the segmentation system.
A caching allows to retrieve the page id in a very brief manner, but it is also stored in a global page table. On modern system, the pagging system might use sub-spaces with layer of tables for better performaces.

A page provide protection keys and eliminates the external fragmentation problem that segments were cause. However, it will create internal fragmentation creating smaller losts within the page.

In a program, data and code are separated within sections that are labelled depending on their content. A process will be split into the following spaces:

- `text` sections are meant to store code, that are fix size and read only. 
- `data` store variable that are already initialized in a read-write section.
- `bss` store other data variables that may be unknown at the init stage like pointers.
- For dynamic allocation, the data are stored within a stack that doesn't have a limit size.

For now, the theorical limit of the 64 bit architecture has not been reach, as it involve astronomous quantity of data.
