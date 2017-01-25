Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x235.google.com (mail-oi0-x235.google.com
 [IPv6:2607:f8b0:4003:c06::235])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 207DC81F07
 for <linux-nvdimm@lists.01.org>; Tue, 24 Jan 2017 18:40:20 -0800 (PST)
Received: by mail-oi0-x235.google.com with SMTP id w204so110154847oiw.0
 for <linux-nvdimm@lists.01.org>; Tue, 24 Jan 2017 18:40:20 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1485311842.12563.50.camel@perches.com>
References: <1485285847-7006-1-git-send-email-bhumirks@gmail.com>
 <1485311842.12563.50.camel@perches.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 24 Jan 2017 18:40:18 -0800
Message-ID: <CAPcyv4i7-vT+-VqU2n4bxrtcwrYtJ5rcVg3=bf5gCx-YRe3HkA@mail.gmail.com>
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
To: Joe Perches <joe@perches.com>
Cc: Julia Lawall <julia.lawall@lip6.fr>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Bhumika Goyal <bhumirks@gmail.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Jan 24, 2017 at 6:37 PM, Joe Perches <joe@perches.com> wrote:
> On Wed, 2017-01-25 at 00:54 +0530, Bhumika Goyal wrote:
>> Declare device_type structure as const as it is only stored in the
>> type field of a device structure. This field is of type const, so add
>> const to declaration of device_type structure.
>>
>> File size before:
>>   text           data     bss     dec     hex filename
>>   19278          3199      16   22493    57dd nvdimm/namespace_devs.o
>>
>> File size after:
>>   text           data     bss     dec     hex filename
>>   19929          3160      16   23105    5a41 nvdimm/namespace_devs.o
>
> Fine, but are you sure about the sizes?
>
> It seems odd the text went up 651 bytes
> while the data went down just 39 bytes.
>

Right, the size data wasn't why I applied it. It was the general rule
of "make function pointer data read-only whenever possible to
eliminate a kernel attack vector".  Bhumika, you might want to mention
this as the motivating reason to apply the patch if you do more of
these changes.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
