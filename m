Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x229.google.com (mail-ot0-x229.google.com
 [IPv6:2607:f8b0:4003:c0f::229])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8C3D02211B43D
 for <linux-nvdimm@lists.01.org>; Mon, 27 Nov 2017 08:15:39 -0800 (PST)
Received: by mail-ot0-x229.google.com with SMTP id b17so24667000oth.2
 for <linux-nvdimm@lists.01.org>; Mon, 27 Nov 2017 08:20:01 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20171127161511.GE5977@quack2.suse.cz>
References: <151068938905.7446.12333914805308312313.stgit@dwillia2-desk3.amr.corp.intel.com>
 <151068939985.7446.15684639617389154187.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20171127161511.GE5977@quack2.suse.cz>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 27 Nov 2017 08:19:59 -0800
Message-ID: <CAPcyv4iayd=dmq18he3EqW-2SO62-s93GLzf8FKWa9s_Pa1Tsw@mail.gmail.com>
Subject: Re: [PATCH v2 2/4] mm: fail get_vaddr_frames() for filesystem-dax
 mappings
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
To: Jan Kara <jack@suse.cz>
Cc: Joonyoung Shim <jy0922.shim@samsung.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Seung-Woo Kim <sw0312.kim@samsung.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>, Inki Dae <inki.dae@samsung.com>, Linux MM <linux-mm@kvack.org>, Kyungmin Park <kyungmin.park@samsung.com>, Mel Gorman <mgorman@suse.de>, Andrew Morton <akpm@linux-foundation.org>, Mauro Carvalho Chehab <mchehab@kernel.org>, Vlastimil Babka <vbabka@suse.cz>, "Linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Nov 27, 2017 at 8:15 AM, Jan Kara <jack@suse.cz> wrote:
> On Tue 14-11-17 11:56:39, Dan Williams wrote:
>> Until there is a solution to the dma-to-dax vs truncate problem it is
>> not safe to allow V4L2, Exynos, and other frame vector users to create
>> long standing / irrevocable memory registrations against filesytem-dax
>> vmas.
>>
>> Cc: Inki Dae <inki.dae@samsung.com>
>> Cc: Seung-Woo Kim <sw0312.kim@samsung.com>
>> Cc: Joonyoung Shim <jy0922.shim@samsung.com>
>> Cc: Kyungmin Park <kyungmin.park@samsung.com>
>> Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
>> Cc: linux-media@vger.kernel.org
>> Cc: Jan Kara <jack@suse.cz>
>> Cc: Mel Gorman <mgorman@suse.de>
>> Cc: Vlastimil Babka <vbabka@suse.cz>
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> Cc: <stable@vger.kernel.org>
>> Fixes: 3565fce3a659 ("mm, x86: get_user_pages() for dax mappings")
>> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>
> Makes sense. I'd just note that in principle get_vaddr_frames() is no more
> long-term than get_user_pages(). It is just so that all the users of
> get_vaddr_frames() currently want a long-term reference. Maybe could you
> add here also a comment that the vma_is_fsdax() check is there because all
> users of this function want a long term page reference? With that you can
> add:

Ok, will do.

> Reviewed-by: Jan Kara <jack@suse.cz>

Thanks.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
