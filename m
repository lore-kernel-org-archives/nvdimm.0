Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com
 [IPv6:2607:f8b0:4864:20::344])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B51EE21193089
 for <linux-nvdimm@lists.01.org>; Sun, 25 Nov 2018 08:38:06 -0800 (PST)
Received: by mail-ot1-x344.google.com with SMTP id s5so14460428oth.7
 for <linux-nvdimm@lists.01.org>; Sun, 25 Nov 2018 08:38:06 -0800 (PST)
MIME-Version: 1.0
References: <154308522458.237140.16550557898744466932.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20181125075410.D0EF220865@mail.kernel.org>
In-Reply-To: <20181125075410.D0EF220865@mail.kernel.org>
From: Dan Williams <dan.j.williams@intel.com>
Date: Sun, 25 Nov 2018 08:37:52 -0800
Message-ID: <CAPcyv4gQmTSqwLUnD2pR0hgJrmRAGEToHNmPZMYQ4+oUmJapRw@mail.gmail.com>
Subject: Re: [PATCH 2/2] libnvdimm,
 pfn: Pad pfn namespaces relative to other regions
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
To: sashal@kernel.org
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, stable <stable@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Sat, Nov 24, 2018 at 11:54 PM Sasha Levin <sashal@kernel.org> wrote:
>
> Hi,
>
> [This is an automated email]
>
> This commit has been processed because it contains a "Fixes:" tag,
> fixing commit: cfe30b872058 libnvdimm, pmem: adjust for section collisions with 'System RAM'.
>
> The bot has tested the following trees: v4.19.4, v4.14.83, v4.9.140.
>
> v4.19.4: Build OK!
> v4.14.83: Build OK!
> v4.9.140: Failed to apply! Possible dependencies:
>     Unable to calculate
>
>
> How should we proceed with this patch?

4.9-stable will need a manual backport since this code was refactored
in the intervening kernel releases.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
