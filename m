Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x22f.google.com (mail-ot0-x22f.google.com
 [IPv6:2607:f8b0:4003:c0f::22f])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id EB1E181E52
 for <linux-nvdimm@lists.01.org>; Tue, 24 Jan 2017 11:58:28 -0800 (PST)
Received: by mail-ot0-x22f.google.com with SMTP id 65so135834709otq.2
 for <linux-nvdimm@lists.01.org>; Tue, 24 Jan 2017 11:58:28 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1485285847-7006-1-git-send-email-bhumirks@gmail.com>
References: <1485285847-7006-1-git-send-email-bhumirks@gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 24 Jan 2017 11:58:27 -0800
Message-ID: <CAPcyv4g5FjW16ALPKymokG7bVF0YL7b54qjbizHfUhCYvTEYvg@mail.gmail.com>
Subject: Re: [PATCH] nvdimm: constify device_type structures
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
To: Bhumika Goyal <bhumirks@gmail.com>
Cc: Julia Lawall <julia.lawall@lip6.fr>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Jan 24, 2017 at 11:24 AM, Bhumika Goyal <bhumirks@gmail.com> wrote:
> Declare device_type structure as const as it is only stored in the
> type field of a device structure. This field is of type const, so add
> const to declaration of device_type structure.
>
> File size before:
>   text     data     bss     dec     hex filename
>   19278    3199      16   22493    57dd nvdimm/namespace_devs.o
>
> File size after:
>   text     data     bss     dec     hex filename
>   19929    3160      16   23105    5a41 nvdimm/namespace_devs.o
>
> Signed-off-by: Bhumika Goyal <bhumirks@gmail.com>

Looks good to me, thanks, applied for 4.11.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
