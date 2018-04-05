Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-io0-x22b.google.com (mail-io0-x22b.google.com
 [IPv6:2607:f8b0:4001:c06::22b])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9E92522526485
 for <linux-nvdimm@lists.01.org>; Thu,  5 Apr 2018 05:43:15 -0700 (PDT)
Received: by mail-io0-x22b.google.com with SMTP id b20so30442769iof.5
 for <linux-nvdimm@lists.01.org>; Thu, 05 Apr 2018 05:43:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87bmexua3s.fsf@concordia.ellerman.id.au>
References: <20180403142415.30083-1-oohall@gmail.com>
 <20180403142415.30083-3-oohall@gmail.com>
 <CAPcyv4jW5H8A96MFD7-UazNSZq-t1_NfrChNB3p9=somdBpsNw@mail.gmail.com>
 <20180404220750.0436bbe1@gmail.com>
 <CAOSf1CGdKU4zQQauqo3UoNvKnKDMHteAEtsMWVtTG7T01csMbg@mail.gmail.com>
 <CAPcyv4if4un9mgFon4ttjKDYEtHC_GP6VoxUENp7YNS50T3afA@mail.gmail.com>
 <CAOSf1CHu4R-t8q-8fL6Dyk7myFR0gTfd6-0cxqtBVGZgYZWGAw@mail.gmail.com>
 <87bmexua3s.fsf@concordia.ellerman.id.au>
From: Oliver <oohall@gmail.com>
Date: Thu, 5 Apr 2018 22:43:14 +1000
Message-ID: <CAOSf1CEUnucUhW_pXG=7h5QBHvaH2-ENPKjGD42_0WEvbU6-Wg@mail.gmail.com>
Subject: Re: [RESEND v2 3/4] doc/devicetree: Persistent memory region bindings
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
To: Michael Ellerman <mpe@ellerman.id.au>
Cc: Device Tree <devicetree@vger.kernel.org>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Apr 5, 2018 at 10:11 PM, Michael Ellerman <mpe@ellerman.id.au> wrote:
> Oliver <oohall@gmail.com> writes:
> ...
>>
>> For context Balbir is working with me on some of the pmem stuff. You
>> probably want an Ack from Rob rather than one of us.
>
> I'll ack it if you make all the niggly nit picky trivial annoying
> changes I asked for :D

*groan*

Fine, I'll respin it tomorrow. If anyone else has comments now would
be the time to make them.

>
> cheers
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
