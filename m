Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6C13A21A0BA94
 for <linux-nvdimm@lists.01.org>; Wed, 10 May 2017 15:03:43 -0700 (PDT)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [PATCH 1/2] x86/MCE: Export memory_error()
Date: Wed, 10 May 2017 22:03:42 +0000
Message-ID: <1494453738.20330.8.camel@intel.com>
References: <CAPcyv4jAkCE2QBuxfxxmZfQZLCVOGLrLXqDu5TyGCVA+xJMEVg@mail.gmail.com>
 <20170421202741.GA16423@intel.com>
 <20170421210704.c5pvpn6zivvruzx3@pd.tnic>
 <20170424113620.6iq2466yhkhb33rp@pd.tnic>
 <20170425210740.GA15722@omniknight.lm.intel.com>
 <1494444606.20330.2.camel@intel.com>
 <20170510200406.mphusoidfuyq24ee@pd.tnic>
 <1494446729.20330.4.camel@intel.com>
 <20170510200851.mhz3434jauxdq2u5@pd.tnic>
 <1494450649.20330.6.camel@intel.com>
 <20170510215707.v7zywrslma4o7jao@pd.tnic>
In-Reply-To: <20170510215707.v7zywrslma4o7jao@pd.tnic>
Content-Language: en-US
Content-ID: <254F45614209294FA4BB4CEE5A41DC2E@intel.com>
MIME-Version: 1.0
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
To: "bp@alien8.de" <bp@alien8.de>
Cc: "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, "Luck," Tony" <tony.luck@intel.com>, "stable@vger.kernel.org, " <stable@vger.kernel.org>, linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, 2017-05-10 at 23:57 +0200, Borislav Petkov wrote:
> On Wed, May 10, 2017 at 09:12:12PM +0000, Verma, Vishal L wrote:
> > The memory error check in the nfit handler is a valid, and simple
> > fix.
> 
> I need the big picture here: "Without this fix, the nfit handler ...".

..will potentially add bogus address to an 'error list', even when there
may not have been a memory error. (can mce->addr have an address when
the mce is not due to a memory error?)
The result of adding an address to this list is that future accesses to
this location will prematurely error out. Depending on how frequently
machine checks happen that are not memory errors but have the addr field
set (hopefully rare anyway), we could be incorrectly marking a lot of
locations as media errors.

> 
> Then, if the stable rules apply, we can always expedite it through
> urgent/stable.
> 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
