Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com
 [IPv6:2607:f8b0:4864:20::343])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E48B021B02822
 for <linux-nvdimm@lists.01.org>; Sun, 25 Nov 2018 13:00:10 -0800 (PST)
Received: by mail-ot1-x343.google.com with SMTP id 40so14799390oth.4
 for <linux-nvdimm@lists.01.org>; Sun, 25 Nov 2018 13:00:10 -0800 (PST)
MIME-Version: 1.0
References: <20181121032702.3048-1-yehs2007@zoho.com>
In-Reply-To: <20181121032702.3048-1-yehs2007@zoho.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Sun, 25 Nov 2018 12:59:59 -0800
Message-ID: <CAPcyv4hmCsNOZPEAzOLxhFCQpyaG0_9TJvJnyuytQAVEU7_wbA@mail.gmail.com>
Subject: Re: [RFC PATCH v2 0/3] realize dax_operations for dm-snapshot
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
To: Huaisheng Ye <yehs2007@zoho.com>
Cc: Jan Kara <jack@suse.cz>, Mike Snitzer <snitzer@redhat.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, NingTing Cheng <chengnt@lenovo.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Matthew Wilcox <willy@infradead.org>, device-mapper development <dm-devel@redhat.com>, zwisler@kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Alasdair Kergon <agk@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Nov 20, 2018 at 7:27 PM Huaisheng Ye <yehs2007@zoho.com> wrote:
>
> From: Huaisheng Ye <yehs1@lenovo.com>
>
> Changes
> v1->v2:
>         Add NULL funtions for origin_dax_direct_access and
>         origin_dax_copy_from/to_iter in order to avoid building
>         error when CONFIG_DAX_DRIVER has NOT been enabled.
>
> [v1]: https://lkml.org/lkml/2018/11/20/759
>
> This series patches are used to realize the dax_operations for dm-snapshot
> with persistent memory device.

How does this interact with mmap write faults if the mapping is dax
and the page needs to be cow'd?
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
