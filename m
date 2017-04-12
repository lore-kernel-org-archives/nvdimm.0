Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x230.google.com (mail-oi0-x230.google.com
 [IPv6:2607:f8b0:4003:c06::230])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id DC95521A0483A
 for <linux-nvdimm@lists.01.org>; Wed, 12 Apr 2017 13:55:23 -0700 (PDT)
Received: by mail-oi0-x230.google.com with SMTP id b187so45980194oif.0
 for <linux-nvdimm@lists.01.org>; Wed, 12 Apr 2017 13:55:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170412205229.GA13659@intel.com>
References: <20170411224457.24777-1-vishal.l.verma@intel.com>
 <20170412091442.dwonfr4dwyta7nvx@pd.tnic>
 <20170412195903.GA29506@omniknight.lm.intel.com>
 <20170412202238.5d327vmwjqvbzzop@pd.tnic> <1492028744.2738.14.camel@intel.com>
 <20170412205229.GA13659@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 12 Apr 2017 13:55:22 -0700
Message-ID: <CAPcyv4j1=Cs84nn6n-9vygSJ2Ei9Z3Gw7hCzyBzo+GyLKWaTUg@mail.gmail.com>
Subject: Re: [RFC PATCH] x86,
 mce: change the mce notifier to 'blocking' from 'atomic'
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
To: "Luck, Tony" <tony.luck@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "x86@kernel.org" <x86@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "bp@suse.de" <bp@suse.de>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Apr 12, 2017 at 1:52 PM, Luck, Tony <tony.luck@intel.com> wrote:
> On Wed, Apr 12, 2017 at 01:27:05PM -0700, Verma, Vishal L wrote:
>> >     /* We only care about memory errors */
>> >     if (!(mce->status & MCACOD))
>> >             return NOTIFY_DONE;
>
> N.B. that isn't a valid test that this is a memory error. You need
>
>
>         if (!(m->status & 0xef80) == BIT(7))
>                 return NOTIFY_DONE;
>
> See: Intel SDM Volume 3B - 15.9.2 Compound Error Codes

But Vishal's point is that even if we get this check correct the
notifier still requires no sleeping operations. So we would need to
move recoverable notifications to a separate blocking notifier chain.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
