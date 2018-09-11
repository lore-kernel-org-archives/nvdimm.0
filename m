Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x242.google.com (mail-oi0-x242.google.com
 [IPv6:2607:f8b0:4003:c06::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6DEEA2112389B
 for <linux-nvdimm@lists.01.org>; Mon, 10 Sep 2018 23:02:13 -0700 (PDT)
Received: by mail-oi0-x242.google.com with SMTP id c190-v6so44915732oig.6
 for <linux-nvdimm@lists.01.org>; Mon, 10 Sep 2018 23:02:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <499a3093-3781-7a8a-abd0-8b240db11dce@intel.com>
References: <20180731143246.16915-1-stefanha@redhat.com>
 <499a3093-3781-7a8a-abd0-8b240db11dce@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 10 Sep 2018 23:02:11 -0700
Message-ID: <CAPcyv4iPCwRCun_w+dE7P86KUC73f6G++sSUS4BFzBzDcsBOpw@mail.gmail.com>
Subject: Re: [PATCH] device-dax: avoid hang on error before
 devm_memremap_pages()
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
To: Dave Jiang <dave.jiang@intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Stefan Hajnoczi <stefanha@redhat.com>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Jul 31, 2018 at 5:26 PM, Dave Jiang <dave.jiang@intel.com> wrote:
>
>
> On 7/31/2018 7:32 AM, Stefan Hajnoczi wrote:
>>
>> dax_pmem_percpu_exit() waits for dax_pmem_percpu_release() to invoke the
>> dax_pmem->cmp completion.  Unfortunately this approach to cleaning up
>> the percpu_ref only works after devm_memremap_pages() was successful.
>>
>> If devm_add_action_or_reset() or devm_memremap_pages() fails,
>> dax_pmem_percpu_release() is not invoked.  Therefore
>> dax_pmem_percpu_exit() hangs waiting for the completion:
>>
>>    rc = devm_add_action_or_reset(dev, dax_pmem_percpu_exit,
>>                                 &dax_pmem->ref);
>>    if (rc)
>>         return rc;
>>
>>    dax_pmem->pgmap.ref = &dax_pmem->ref;
>>    addr = devm_memremap_pages(dev, &dax_pmem->pgmap);
>>
>> Avoid the hang by calling percpu_ref_exit() in the error paths instead
>> of going through dax_pmem_percpu_exit().
>>
>> Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
>
>
> Applied
>

A similar problem exists in other devm_memremap_pages() users. I had a
more comprehensive fix in-flight that I will rebase on top of this
change.

    https://lore.kernel.org/patchwork/patch/961576/
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
