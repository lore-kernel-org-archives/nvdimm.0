Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-io0-x233.google.com (mail-io0-x233.google.com
 [IPv6:2607:f8b0:4001:c06::233])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id AAEE021E1B76E
 for <linux-nvdimm@lists.01.org>; Thu, 21 Sep 2017 12:13:19 -0700 (PDT)
Received: by mail-io0-x233.google.com with SMTP id g32so13209865ioj.2
 for <linux-nvdimm@lists.01.org>; Thu, 21 Sep 2017 12:16:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <2089147046.4992297.1505888525001@mail.yahoo.com>
References: <2089147046.4992297.1505888525001.ref@mail.yahoo.com>
 <2089147046.4992297.1505888525001@mail.yahoo.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 21 Sep 2017 12:16:25 -0700
Message-ID: <CAPcyv4gRdiMTnx6+K9gGi6sSc4strDV6qhhWX+n5xBwp=HfPBA@mail.gmail.com>
Subject: Re: Segmentation fault when running "make M=tools/testing/nvdimm"
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
To: Soccer Liu <soccer_liu@yahoo.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Sep 19, 2017 at 11:22 PM, Soccer Liu <soccer_liu@yahoo.com> wrote:
>
> Hi:  As part of processing in setting up the environment for running unitests, I was able to work through the instrcutions in https://github.com/pmem/ndctl/tree/0a628fdf4fe58a283b16c1bbaa49bb28b1842bf9
> all the way until I hit the followingbuild error (Segmentation fault) when buiding libnvdimm.o.Anyone hit this before?root@ubuntu:/home/soccerl/nvdimm#  make M=tools/testing/nvdimm
>   AR      tools/testing/nvdimm/built-in.o
>   CC [M]  tools/testing/nvdimm/../../../drivers/nvdimm/core.o
>   CC [M]  tools/testing/nvdimm/../../../drivers/nvdimm/bus.o
>   CC [M]  tools/testing/nvdimm/../../../drivers/nvdimm/dimm_devs.o
>   CC [M]  tools/testing/nvdimm/../../../drivers/nvdimm/dimm.o
>   CC [M]  tools/testing/nvdimm/../../../drivers/nvdimm/region_devs.o
>   CC [M]  tools/testing/nvdimm/../../../drivers/nvdimm/region.o
>   CC [M]  tools/testing/nvdimm/../../../drivers/nvdimm/namespace_devs.o
>   CC [M]  tools/testing/nvdimm/../../../drivers/nvdimm/label.o
>   CC [M]  tools/testing/nvdimm/../../../drivers/nvdimm/claim.o
>   CC [M]  tools/testing/nvdimm/../../../drivers/nvdimm/btt_devs.o
>   CC [M]  tools/testing/nvdimm/../../../drivers/nvdimm/pfn_devs.o
>   CC [M]  tools/testing/nvdimm/../../../drivers/nvdimm/dax_devs.o
>   CC [M]  tools/testing/nvdimm/config_check.o
>   LD [M]  tools/testing/nvdimm/libnvdimm.o
> Segmentation fault
> scripts/Makefile.build:548: recipe for target 'tools/testing/nvdimm/libnvdimm.o' failed
> make[1]: *** [tools/testing/nvdimm/libnvdimm.o] Error 139
> Makefile:1511: recipe for target '_module_tools/testing/nvdimm' failed
> make: *** [_module_tools/testing/nvdimm] Error 2My devbox has 4.13 Linux in it.
> I am not sure whether it has anything to do with fact that I didnt do anything with ndctl/ndctl.spec.in (because I am not sure how to apply those dependendies to my testbox) Thanks

No, this seems like a bug in your toolchain. What version of gcc are
you running?
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
