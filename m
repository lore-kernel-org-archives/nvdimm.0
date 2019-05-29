Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x242.google.com (mail-oi1-x242.google.com
 [IPv6:2607:f8b0:4864:20::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 43FEA2128DD24
 for <linux-nvdimm@lists.01.org>; Tue, 28 May 2019 19:13:39 -0700 (PDT)
Received: by mail-oi1-x242.google.com with SMTP id w144so731556oie.12
 for <linux-nvdimm@lists.01.org>; Tue, 28 May 2019 19:13:39 -0700 (PDT)
MIME-Version: 1.0
References: <20190528222440.30392-1-vishal.l.verma@intel.com>
 <20190528222440.30392-4-vishal.l.verma@intel.com>
In-Reply-To: <20190528222440.30392-4-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 28 May 2019 19:13:26 -0700
Message-ID: <CAPcyv4hsk66TBg-6V_quSHpZ7fx8S3tu8i4-30nwHoGvSMsZZw@mail.gmail.com>
Subject: Re: [ndctl PATCH v4 03/10] libdaxctl: add interfaces to
 enable/disable devices
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
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>, Pavel Tatashin <pasha.tatashin@soleen.com>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, May 28, 2019 at 3:24 PM Vishal Verma <vishal.l.verma@intel.com> wrote:
>
> Add new libdaxctl interfaces to disable a device_dax based devices, and
> to enable it into a given mode. The modes available are 'device_dax',

Does this mode name get exposed to the command line interface? If
"yes", I think this should be 'devdax' to match the ndctl namespace
mode, or just 'device', but otherwise no "_" in any command-line
interfaces. Otherwise I think the module names are an internal
implementation detail of the kernel ABI and need not leak further than
the libdaxctl to kernel interface.

> and 'system-ram', where device_dax is the normal device DAX mode used
> via a character device, and 'system-ram' uses the kernel's 'kmem'
> facility to hotplug the device into the system's memory space, and can
> be used as normal system memory.
>
> This adds the following new interfaces:
>
>   daxctl_dev_disable;
>   daxctl_dev_enable_devdax;
>   daxctl_dev_enable_ram;
>
> Cc: Dave Hansen <dave.hansen@linux.intel.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
