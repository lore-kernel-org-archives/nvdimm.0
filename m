Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com
 [IPv6:2607:f8b0:4864:20::341])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id CF9102129F0EB
 for <linux-nvdimm@lists.01.org>; Thu, 20 Jun 2019 17:53:48 -0700 (PDT)
Received: by mail-ot1-x341.google.com with SMTP id e8so4632442otl.7
 for <linux-nvdimm@lists.01.org>; Thu, 20 Jun 2019 17:53:48 -0700 (PDT)
MIME-Version: 1.0
References: <20190621004038.15180-1-vishal.l.verma@intel.com>
In-Reply-To: <20190621004038.15180-1-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 20 Jun 2019 17:53:36 -0700
Message-ID: <CAPcyv4hzK12RKns5pybmy=5B-yfCQ+-C4FO+2kRGjRZP4wa5GQ@mail.gmail.com>
Subject: Re: [PATCH] device-dax: Add a 'resource' attribute
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
Cc: Dave Hansen <dave.hansen@linux.intel.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Jun 20, 2019 at 5:41 PM Vishal Verma <vishal.l.verma@intel.com> wrote:
>
> device-dax based devices were missing a 'resource' attribute to indicate
> the physical address range contributed by the device in question. This
> information is desirable to userspace tooling that may want to use the
> dax device as system-ram, and wants to selectively hotplug and online
> the memory blocks associated with a given device.
>
> Without this, the tooling would have to parse /proc/iomem for the memory
> ranges contributed by dax devices, which can be a workaround, but it is
> far easier to provide this information in the sysfs hierarchy.
>
> Cc: Dave Hansen <dave.hansen@linux.intel.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>

Looks good to me, applied.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
