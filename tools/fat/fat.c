#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

typedef uint8_t bool;
#define true 1
#define false 0

typedef struct
{
    // BIOS parameter block(BPB) variables - https://wiki.osdev.org/FAT#BPB_.28BIOS_Parameter_Block.29
    uint8_t boot_jump_instruction[3];
    uint8_t oem_identifier[8];
    uint16_t bytes_per_sector;
    uint8_t sector_per_cluster;
    uint16_t reserved_sectors;
    uint8_t fat_count;
    uint16_t dir_entry_count;
    uint16_t total_sector_count;
    uint8_t media_descriptor_type;
    uint16_t sectors_per_fat;
    uint16_t sectors_per_track;
    uint16_t heads;
    uint32_t hidden_sectors_count;
    uint32_t large_sectors_count;

    // Extended Boot Record (EBR) variables - https://wiki.osdev.org/FAT#Extended_Boot_Record
    uint8_t drive_serial_number;
    uint8_t _reserved;
    uint8_t signature;
    uint32_t volume_id;
    uint8_t volume_label[11];
    uint8_t system_id[8];

} __attribute__((packed)) bootsector;

typedef struct
{
    uint8_t name[11];
    uint8_t attributes;
    uint8_t _reserved;
    uint8_t created_time_tenths;
    uint16_t created_time;
    uint16_t created_date;
    uint16_t accessed_date;
    uint16_t first_cluster_high;
    uint16_t modified_time;
    uint16_t modified_date;
    uint16_t first_cluster_low;
    uint32_t size;
} __attribute__((packed)) directory_entry;

bootsector global_bootsector;

bool read_boot_sector(FILE *disk);

int main(int argc, char **argv)
{
    if (argc > 3)
    {
        printf("Syntax: \"%s\" <disk image> <file name>\n", argv[0]);
        return -1;
    }

    FILE *disk = fopen(argv[1], "rb");

    if (!disk)
    {
        fprintf(stderr, "Cannot open disk image \"%s\"!", argv[1]);
        return -1;
    }

    if (!read_boot_sector)
    {
        fprintf(stderr, "Could not read boot sector!\n");
        return -2;
    }

    return 0;
}

bool read_boot_sector(FILE *disk)
{
    return fread(&global_bootsector, sizeof(global_bootsector), 1, disk) > 0;
}