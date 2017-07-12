Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-yw0-x22d.google.com (mail-yw0-x22d.google.com
 [IPv6:2607:f8b0:4002:c05::22d])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0C18221A00AE5
 for <linux-nvdimm@lists.01.org>; Wed, 12 Jul 2017 09:03:36 -0700 (PDT)
Received: by mail-yw0-x22d.google.com with SMTP id l21so12440242ywb.1
 for <linux-nvdimm@lists.01.org>; Wed, 12 Jul 2017 09:05:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170712192518.C683.E1E9C6FF@jp.fujitsu.com>
References: <20170712192518.C683.E1E9C6FF@jp.fujitsu.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 12 Jul 2017 09:05:21 -0700
Message-ID: <CAPcyv4hHBntujti2bDmB5WaBab=hCVphO=X-yVa4pJJ0iLP2PQ@mail.gmail.com>
Subject: Re: Some thoughts of ndctl list command output
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
To: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: NVDIMM-ML <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Jul 12, 2017 at 3:25 AM, Yasunori Goto <y-goto@jp.fujitsu.com> wrote:
> Hello,
>
> I wrote current impression about ndctl.
> If my understanding/thoughts is wrong, please correct me.
>
>
> Please imagine the following situation.
>
>   - There are 2 NVDIMMs like the following figure.
>   - An interleaved region(namespace) is created on NVDIMM 1 and 2,
>     and it is /dev/pmem1.
>   - A storage region is created on NVDIMM 1 too, it is /dev/pmem2s.
>   - Another storage region is created on NVDIMM 2 as /dev/pmem3s.
>
>   +-------------------+-------------------+
>   |                   |    /dev/pmem2s    |   NVDIMM 1 (nmem1)
>   |/dev/pmem1     X   +-------------------+
>   |                   |    /dev/pmem3s    |   NVDIMM 2 (nmem2)
>   +-------------------+-------------------+
>
>
>   If a place (in the above figure, place "X") is broken and scrubbing can not
>   solve error, user will need to replace broken NVDIMM.
>
>   But, how does user can know which NVDIMM is broken?
>   Currently, badblock data belongs to region, not DIMM module,
>   there is no information which nvdimm has badblock.
>
>   In addition, even if user can find that badblock is included in NVDIMM 2
>   fortunately, then he/she needs to become aware that /dev/pmem3s is
>   also included in NVDIMM 2, because he/she need to backup the region
>   before replacing NVDIMM 2.
>
>   However, I suppose it may be a bit difficult for user to be aware of it.
>   Because current ndctl does NOT output
>   "Which region is included on the (broken) NVDIMM module."
>   It can output only
>   "Which NVDIMM is used for the region by "ndctl list -RD".
>
>   As a result, he/she has to SEARCH all of the regions which is mapped on
>   "nmem2". It may be a bit troublesome for users, I think.
>
>
>   In summary, I think...
>     - Badblock information on each NVDIMM will be helpful for user to replace
>       wrong NVDIMM.
>     - ndctl list -D need to output the information which regions/namespaces
>       are placed on each NVDIMM.

You analysis is correct.

Prior to ACPI 6.2 we would need to walk through the
interleave-descriptor tables to discover the translation of the
system-physical-address to a DIMM+offset. However, we now have the
"Translate SPA" _DSM which should make it easy for ndctl to translate
"badblocks" information at a region level back to a specific DIMM.
I'll add this to the feature backlog, but if you or anyone else wants
to take a look at using that translation command to generate the
per-dimm badblocks list for ndctl I'd gladly take the patches.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
