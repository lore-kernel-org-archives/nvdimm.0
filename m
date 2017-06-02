Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 39ED221A08D89
 for <linux-nvdimm@lists.01.org>; Fri,  2 Jun 2017 14:22:14 -0700 (PDT)
From: "Moore, Robert" <robert.moore@intel.com>
Subject: RE: [RFC 1/6] ACPICA: add HMAT table definitions
Date: Fri, 2 Jun 2017 21:23:14 +0000
Message-ID: <94F2FBAB4432B54E8AACC7DFDE6C92E37E5BD764@ORSMSX110.amr.corp.intel.com>
References: <20170602205956.28351-1-ross.zwisler@linux.intel.com>
 <20170602205956.28351-2-ross.zwisler@linux.intel.com>
In-Reply-To: <20170602205956.28351-2-ross.zwisler@linux.intel.com>
Content-Language: en-US
MIME-Version: 1.0
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Ross Zwisler <ross.zwisler@linux.intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "Kogut, Jaroslaw" <Jaroslaw.Kogut@intel.com>, "Wysocki, Rafael J  <rafael.j.wysocki@intel.com>, Tim Chen <tim.c.chen@linux.intel.com>, Hansen, Dave" <dave.hansen@intel.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Nachimuthu,, "Lukasz  <lukasz.anaczkowski@intel.com>, Greg Kroah-Hartman" <gregkh@linuxfoundation.org>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, Box,, "Joonas  <joonas.lahtinen@intel.com>, linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "Odzioba, Lukasz  <lukasz.odzioba@intel.com>, Dave Hansen" <dave.hansen@linux.intel.com>, "Zheng, Lv" <lv.zheng@intel.com>, "devel@acpica.org" <devel@acpica.org>, Schmauss,
List-ID: <linux-nvdimm@lists.01.org>

Full support for HMAT was just released in ACPICA version 20170531.


> -----Original Message-----
> From: Ross Zwisler [mailto:ross.zwisler@linux.intel.com]
> Sent: Friday, June 2, 2017 2:00 PM
> To: linux-kernel@vger.kernel.org
> Cc: Ross Zwisler <ross.zwisler@linux.intel.com>; Anaczkowski, Lukasz
> <lukasz.anaczkowski@intel.com>; Box, David E <david.e.box@intel.com>;
> Kogut, Jaroslaw <Jaroslaw.Kogut@intel.com>; Lahtinen, Joonas
> <joonas.lahtinen@intel.com>; Moore, Robert <robert.moore@intel.com>;
> Nachimuthu, Murugasamy <murugasamy.nachimuthu@intel.com>; Odzioba,
> Lukasz <lukasz.odzioba@intel.com>; Wysocki, Rafael J
> <rafael.j.wysocki@intel.com>; Rafael J. Wysocki <rjw@rjwysocki.net>;
> Schmauss, Erik <erik.schmauss@intel.com>; Verma, Vishal L
> <vishal.l.verma@intel.com>; Zheng, Lv <lv.zheng@intel.com>; Williams,
> Dan J <dan.j.williams@intel.com>; Hansen, Dave <dave.hansen@intel.com>;
> Dave Hansen <dave.hansen@linux.intel.com>; Greg Kroah-Hartman
> <gregkh@linuxfoundation.org>; Len Brown <lenb@kernel.org>; Tim Chen
> <tim.c.chen@linux.intel.com>; devel@acpica.org; linux-
> acpi@vger.kernel.org; linux-nvdimm@lists.01.org
> Subject: [RFC 1/6] ACPICA: add HMAT table definitions
> 
> Import HMAT table definitions from the ACPICA codebase.
> 
> This kernel patch was generated using an ACPICA patch from "Zheng, Lv"
> <lv.zheng@intel.com>.  The actual upstream patch that adds these table
> definitions will come from the Intel ACPICA team as part of their
> greater ACPI 6.2 update.
> 
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> ---
>  include/acpi/actbl1.h | 119
> ++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 119 insertions(+)
> 
> diff --git a/include/acpi/actbl1.h b/include/acpi/actbl1.h index
> b4ce55c..a5df3f3 100644
> --- a/include/acpi/actbl1.h
> +++ b/include/acpi/actbl1.h
> @@ -65,6 +65,7 @@
>  #define ACPI_SIG_ECDT           "ECDT"	/* Embedded Controller Boot
> Resources Table */
>  #define ACPI_SIG_EINJ           "EINJ"	/* Error Injection table */
>  #define ACPI_SIG_ERST           "ERST"	/* Error Record Serialization
> Table */
> +#define ACPI_SIG_HMAT           "HMAT"  /* Heterogeneous Memory
> Attributes Table */
>  #define ACPI_SIG_HEST           "HEST"	/* Hardware Error Source
> Table */
>  #define ACPI_SIG_MADT           "APIC"	/* Multiple APIC Description
> Table */
>  #define ACPI_SIG_MSCT           "MSCT"	/* Maximum System
> Characteristics Table */
> @@ -688,6 +689,124 @@ struct acpi_hest_generic_data_v300 {
> 
> 
> /***********************************************************************
> ********
>   *
> + * HMAT - Heterogeneous Memory Attributes Table (ACPI 6.2)
> + *        Version 1
> + *
> + **********************************************************************
> + ********/
> +
> +struct acpi_table_hmat {
> +	struct acpi_table_header header; /* Common ACPI table header */
> +	u32 reserved;
> +};
> +
> +
> +/* Values for HMAT structure types */
> +
> +enum acpi_hmat_type {
> +	ACPI_HMAT_TYPE_ADDRESS_RANGE = 0, /* Memory subystem address range
> */
> +	ACPI_HMAT_TYPE_LOCALITY      = 1, /* System locality latency and
> bandwidth information */
> +	ACPI_HMAT_TYPE_CACHE         = 2, /* Memory side cache information
> */
> +	ACPI_HMAT_TYPE_RESERVED      = 3  /* 3 and greater are reserved */
> +};
> +
> +struct acpi_hmat_structure {
> +	u16 type;
> +	u16 reserved;
> +	u32 length;
> +};
> +
> +/*
> + * HMAT Structures, correspond to Type in struct acpi_hmat_structure
> +*/
> +
> +/* 0: Memory subystem address range */
> +
> +struct acpi_hmat_address_range {
> +	struct acpi_hmat_structure header;
> +	u16 flags;
> +	u16 reserved1;
> +	u32 processor_PD;           /* Processor proximity domain */
> +	u32 memory_PD;              /* Memory proximity domain */
> +	u32 reserved2;
> +	u64 physical_address_base;  /* Physical address range base */
> +	u64 physical_address_length; /* Physical address range length */ };
> +
> +/* Masks for Flags field above */
> +
> +#define ACPI_HMAT_PROCESSOR_PD_VALID (1)    /* 1: processor_PD field is
> valid */
> +#define ACPI_HMAT_MEMORY_PD_VALID    (1<<1) /* 1: memory_PD field is
> valid */
> +#define ACPI_HMAT_RESERVATION_HINT   (1<<2) /* 1: Reservation hint */
> +
> +/* 1: System locality latency and bandwidth information */
> +
> +struct acpi_hmat_locality {
> +	struct acpi_hmat_structure header;
> +	u8  flags;
> +	u8  data_type;
> +	u16 reserved1;
> +	u32 number_of_initiator_Pds;
> +	u32 number_of_target_Pds;
> +	u32 reserved2;
> +	u64 entry_base_unit;
> +	u32 data[1]; /* initiator/target lists followed by entry matrix */
> };
> +
> +/* Masks for Flags field above */
> +
> +#define ACPI_HMAT_MEMORY_HIERARCHY  (0x0F)
> +
> +/* Values for Memory Hierarchy flag */
> +
> +#define ACPI_HMAT_MEMORY            0
> +#define ACPI_HMAT_LAST_LEVEL_CACHE  1
> +#define ACPI_HMAT_1ST_LEVEL_CACHE   2
> +#define ACPI_HMAT_2ND_LEVEL_CACHE   3
> +#define ACPI_HMAT_3RD_LEVEL_CACHE   4
> +
> +/* Values for data_type field above */
> +
> +#define ACPI_HMAT_ACCESS_LATENCY    0
> +#define ACPI_HMAT_READ_LATENCY      1
> +#define ACPI_HMAT_WRITE_LATENCY     2
> +#define ACPI_HMAT_ACCESS_BANDWIDTH  3
> +#define ACPI_HMAT_READ_BANDWIDTH    4
> +#define ACPI_HMAT_WRITE_BANDWIDTH   5
> +
> +/* 2: Memory side cache information */
> +
> +struct acpi_hmat_cache {
> +	struct acpi_hmat_structure header;
> +	u32 memory_PD;
> +	u32 reserved1;
> +	u64 cache_size;
> +	u32 cache_attributes;
> +	u16 reserved2;
> +	u16 number_of_SMBIOShandles;
> +};
> +
> +/* Masks for cache_attributes field above */
> +
> +#define ACPI_HMAT_TOTAL_CACHE_LEVEL     (0x0000000F)
> +#define ACPI_HMAT_CACHE_LEVEL           (0x000000F0)
> +#define ACPI_HMAT_CACHE_ASSOCIATIVITY   (0x00000F00)
> +#define ACPI_HMAT_WRITE_POLICY          (0x0000F000)
> +#define ACPI_HMAT_CACHE_LINE_SIZE       (0xFFFF0000)
> +
> +/* Values for cache associativity flag */
> +
> +#define ACPI_HMAT_CA_NONE                     (0)
> +#define ACPI_HMAT_CA_DIRECT_MAPPED            (1)
> +#define ACPI_HMAT_CA_COMPLEX_CACHE_INDEXING   (2)
> +
> +/* Values for write policy flag */
> +
> +#define ACPI_HMAT_CP_NONE   (0)
> +#define ACPI_HMAT_CP_WB     (1)
> +#define ACPI_HMAT_CP_WT     (2)
> +
> +/**********************************************************************
> +*********
> + *
>   * MADT - Multiple APIC Description Table
>   *        Version 3
>   *
> --
> 2.9.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
