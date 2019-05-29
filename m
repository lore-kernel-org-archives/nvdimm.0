Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B4F2E2125ADF6
 for <linux-nvdimm@lists.01.org>; Wed, 29 May 2019 09:55:50 -0700 (PDT)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [ndctl PATCH v4 03/10] libdaxctl: add interfaces to
 enable/disable devices
Date: Wed, 29 May 2019 16:55:47 +0000
Message-ID: <b3bd78d1e81521056b8e74679d7cc68a7d14a70a.camel@intel.com>
References: <20190528222440.30392-1-vishal.l.verma@intel.com>
 <20190528222440.30392-4-vishal.l.verma@intel.com>
 <CAPcyv4hsk66TBg-6V_quSHpZ7fx8S3tu8i4-30nwHoGvSMsZZw@mail.gmail.com>
In-Reply-To: <CAPcyv4hsk66TBg-6V_quSHpZ7fx8S3tu8i4-30nwHoGvSMsZZw@mail.gmail.com>
Content-Language: en-US
Content-ID: <AD471FCA655DD74FB231897E5B51EB74@intel.com>
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
To: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "pasha.tatashin@soleen.com" <pasha.tatashin@soleen.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>


On Tue, 2019-05-28 at 19:13 -0700, Dan Williams wrote:
> On Tue, May 28, 2019 at 3:24 PM Vishal Verma <vishal.l.verma@intel.com> wrote:
> > Add new libdaxctl interfaces to disable a device_dax based devices, and
> > to enable it into a given mode. The modes available are 'device_dax',
> 
> Does this mode name get exposed to the command line interface? If
> "yes", I think this should be 'devdax' to match the ndctl namespace
> mode, or just 'device', but otherwise no "_" in any command-line
> interfaces. Otherwise I think the module names are an internal
> implementation detail of the kernel ABI and need not leak further than
> the libdaxctl to kernel interface.

The command line option is just 'devdax', but good catch in that I will
fix up this commit message.

> 
> > and 'system-ram', where device_dax is the normal device DAX mode used
> > via a character device, and 'system-ram' uses the kernel's 'kmem'
> > facility to hotplug the device into the system's memory space, and can
> > be used as normal system memory.
> > 
> > This adds the following new interfaces:
> > 
> >   daxctl_dev_disable;
> >   daxctl_dev_enable_devdax;
> >   daxctl_dev_enable_ram;
> > 
> > Cc: Dave Hansen <dave.hansen@linux.intel.com>
> > Cc: Dan Williams <dan.j.williams@intel.com>
> > Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
