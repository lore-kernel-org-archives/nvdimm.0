Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8871421939234
 for <linux-nvdimm@lists.01.org>; Wed, 12 Apr 2017 13:52:30 -0700 (PDT)
Date: Wed, 12 Apr 2017 13:52:30 -0700
From: "Luck, Tony" <tony.luck@intel.com>
Subject: Re: [RFC PATCH] x86, mce: change the mce notifier to 'blocking' from
 'atomic'
Message-ID: <20170412205229.GA13659@intel.com>
References: <20170411224457.24777-1-vishal.l.verma@intel.com>
 <20170412091442.dwonfr4dwyta7nvx@pd.tnic>
 <20170412195903.GA29506@omniknight.lm.intel.com>
 <20170412202238.5d327vmwjqvbzzop@pd.tnic>
 <1492028744.2738.14.camel@intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1492028744.2738.14.camel@intel.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: "Verma, Vishal L" <vishal.l.verma@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "x86@kernel.org" <x86@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "bp@suse.de" <bp@suse.de>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Apr 12, 2017 at 01:27:05PM -0700, Verma, Vishal L wrote:
> > =A0	/* We only care about memory errors */
> > =A0	if (!(mce->status & MCACOD))
> > =A0		return NOTIFY_DONE;

N.B. that isn't a valid test that this is a memory error. You need


	if (!(m->status & 0xef80) =3D=3D BIT(7))
		return NOTIFY_DONE;

See: Intel SDM Volume 3B - 15.9.2 Compound Error Codes

-Tony
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
