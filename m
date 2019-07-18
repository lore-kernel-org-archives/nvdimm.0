Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x244.google.com (mail-oi1-x244.google.com
 [IPv6:2607:f8b0:4864:20::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id CD320212C01DB
 for <linux-nvdimm@lists.01.org>; Wed, 17 Jul 2019 18:59:01 -0700 (PDT)
Received: by mail-oi1-x244.google.com with SMTP id t76so20235688oih.4
 for <linux-nvdimm@lists.01.org>; Wed, 17 Jul 2019 18:56:33 -0700 (PDT)
MIME-Version: 1.0
References: <20190717225400.9494-1-vishal.l.verma@intel.com>
 <20190717225400.9494-4-vishal.l.verma@intel.com>
In-Reply-To: <20190717225400.9494-4-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 17 Jul 2019 18:56:21 -0700
Message-ID: <CAPcyv4jsY1veeB46zJ8+G3a8L512=buW4jLY11tzoDopx+DgOA@mail.gmail.com>
Subject: Re: [ndctl PATCH v6 03/13] libdaxctl: add an interface to retrieve
 the device resource
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
Cc: Tony Luck <tony.luck@intel.com>, Dave Hansen <dave.hansen@linux.intel.com>, Pavel Tatashin <pasha.tatashin@soleen.com>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Jul 17, 2019 at 3:54 PM Vishal Verma <vishal.l.verma@intel.com> wrote:
>
> Add an interface to retrieve the 'resource' attribute for a dax device.
>
> Attempt to retrieve it as usual via sysfs, but since older kernels may
> be missing this attribute, as a fallback, attempt to retrieve it from
> /proc/iomem
>
> Cc: Dan Williams <dan.j.williams@intel.com>
> [fscanf format string problem and diagnosis]
> Reported-by: Tony Luck <tony.luck@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>

Looks ok, just wish we had added a dax resource sysfs attribute
earlier. That fscanf() line is a work of art.

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
