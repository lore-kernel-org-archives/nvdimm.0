Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com
 [IPv6:2a00:1450:4864:20::543])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 94EFB21CB74A4
 for <linux-nvdimm@lists.01.org>; Fri, 17 May 2019 08:31:03 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id p27so11209418eda.1
 for <linux-nvdimm@lists.01.org>; Fri, 17 May 2019 08:31:02 -0700 (PDT)
MIME-Version: 1.0
References: <20190516224053.3655-1-vishal.l.verma@intel.com>
In-Reply-To: <20190516224053.3655-1-vishal.l.verma@intel.com>
From: Pavel Tatashin <pasha.tatashin@soleen.com>
Date: Fri, 17 May 2019 11:30:50 -0400
Message-ID: <CA+CK2bCEUjCNGHcfqh+4gxtf80eUkz_swNny6A2mkJwLi6Yn+Q@mail.gmail.com>
Subject: Re: [ndctl PATCH v3 00/10] daxctl: add a new reconfigure-device
 command
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
Cc: Dave Hansen <dave.hansen@linux.intel.com>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, May 16, 2019 at 6:40 PM Vishal Verma <vishal.l.verma@intel.com> wrote:
>
> Changes in v3:
>  - In daxctl_dev_get_mode(), remove the subsystem warning, detect dax-class
>    and simply make it return devdax

Hi Vishal,

I am still getting the same error as before:

# ndctl create-namespace --mode devdax --map mem -e namespace0.0 -f
[  141.525873] dax0.0 initialised, 524288 pages in 7ms
libdaxctl: __sysfs_device_parse: dax0.0: add_dev() failed
...

I am building it via buildroot, and can share the initramfs file or
anything that can help you with fixing this issue.

Thank you,
Pavel
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
