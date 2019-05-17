Return-Path: <owner-linux-mm@kvack.org>
MIME-Version: 1.0
References: <CA+CK2bBeOJPnnyWBgj0CJ7E1z9GVWVg_EJAmDs07BSJDp3PYfQ@mail.gmail.com>
 <20190517143816.GO6836@dhcp22.suse.cz> <CA+CK2bA+2+HaV4GWNUNP04fjjTPKbEGQHSPrSrmY7HLD57au1Q@mail.gmail.com>
In-Reply-To: <CA+CK2bA+2+HaV4GWNUNP04fjjTPKbEGQHSPrSrmY7HLD57au1Q@mail.gmail.com>
From: Pavel Tatashin <pasha.tatashin@soleen.com>
Date: Fri, 17 May 2019 13:24:50 -0400
Message-ID: <CA+CK2bDq+2qu28afO__4kzO4=cnLH1P4DcHjc62rt0UtYwLm0A@mail.gmail.com>
Subject: Re: NULL pointer dereference during memory hotremove
Content-Type: text/plain; charset="UTF-8"
Sender: owner-linux-mm@kvack.org
To: Michal Hocko <mhocko@kernel.org>
Cc: "Verma, Vishal L" <vishal.l.verma@intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "jmorris@namei.org" <jmorris@namei.org>, "tiwai@suse.de" <tiwai@suse.de>, "sashal@kernel.org" <sashal@kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "david@redhat.com" <david@redhat.com>, "bp@suse.de" <bp@suse.de>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "jglisse@redhat.com" <jglisse@redhat.com>, "zwisler@kernel.org" <zwisler@kernel.org>, "Jiang, Dave" <dave.jiang@intel.com>, "bhelgaas@google.com" <bhelgaas@google.com>, "Busch, Keith" <keith.busch@intel.com>, "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "Huang, Ying" <ying.huang@intel.com>, "Wu, Fengguang" <fengguang.wu@intel.com>, "baiyaowei@cmss.chinamobile.com" <baiyaowei@cmss.chinamobile.com>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, May 17, 2019 at 1:22 PM Pavel Tatashin
<pasha.tatashin@soleen.com> wrote:
>
> On Fri, May 17, 2019 at 10:38 AM Michal Hocko <mhocko@kernel.org> wrote:
> >
> > On Fri 17-05-19 10:20:38, Pavel Tatashin wrote:
> > > This panic is unrelated to circular lock issue that I reported in a
> > > separate thread, that also happens during memory hotremove.
> > >
> > > xakep ~/x/linux$ git describe
> > > v5.1-12317-ga6a4b66bd8f4
> >
> > Does this happen on 5.0 as well?
>
> Yes, just reproduced it on 5.0 as well. Unfortunately, I do not have a
> script, and have to do it manually, also it does not happen every
> time, it happened on 3rd time for me.

Actually, sorry, I have not tested 5.0, I compiled 5.0, but my script
still tested v5.1-12317-ga6a4b66bd8f4 build. I will report later if I
am able to reproduce it on 5.0.

Pasha
