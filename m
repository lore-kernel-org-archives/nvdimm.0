Return-Path: <linux-kernel-owner@vger.kernel.org>
From: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>
Subject: RE: [PATCH 1/4] nvdimm: Add wrapper for IOCTL pass thru.
Date: Tue, 10 Nov 2015 19:04:22 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B40295BE160C5@G4W3202.americas.hpqcorp.net>
References: <cover.1446684001.git.jerry.hoemann@hpe.com>
 <5411049831df211c8280e3239aaf344af033fa25.1446684001.git.jerry.hoemann@hpe.com>
In-Reply-To: <5411049831df211c8280e3239aaf344af033fa25.1446684001.git.jerry.hoemann@hpe.com>
Content-Language: en-US
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
To: "Hoemann, Jerry" <jerry.hoemann@hpe.com>, "ross.zwisler@linux.intel.com" <ross.zwisler@linux.intel.com>, "rjw@rjwysocki.net" <rjw@rjwysocki.net>, "lenb@kernel.org" <lenb@kernel.org>, "dan.j.williams@intel.com" <dan.j.williams@intel.com>
Cc: "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

> -----Original Message-----
> From: Linux-nvdimm [mailto:linux-nvdimm-bounces@lists.01.org] On Behalf Of
> Hoemann, Jerry
> Sent: Friday, November 6, 2015 4:27 PM
> Subject: [PATCH 1/4] nvdimm: Add wrapper for IOCTL pass thru.
...
> diff --git a/include/uapi/linux/ndctl.h b/include/uapi/linux/ndctl.h
...
> +struct ndn_pkg {
> +	struct {
> +		__u8	dsm_uuid[16];
> +		__u32	dsm_in;			/* size of _DSM input    */
> +		__u32	dsm_out;		/* size of user buffer   */
> +		__u32	dsm_rev;		/* revision of dsm call  */
> +		__u32	res[8];			/* reserved must be zero */
> +		__u32	dsm_size;		/* size _DSM would write */
> +	} h;
> +	unsigned char buf[];
> +} __packed;

Given that the _DSM arguments are defined as:
* Arg0 UUID: Buffer of 16 bytes
* Arg1 Revision ID: Integer (8 bytes)
* Arg2 Function Index: Integer (8 bytes)
* Arg3 Package: function-specific

1. The __u32 for dsm_rev is not big enough to express all
possible 8 byte Revision IDs.

2. The unsigned int cmd (carried outside this structure)
is not big enough on all platforms (e.g., 32-bit) to 
express all possible Function Indexes.

3. The Revision ID and Function Index values passed to 
the _DSM are defined as little-endian.  Are they
intended to use native endianness or be little-endian
in this structure?

---
Robert Elliott, HPE Persistent Memory



