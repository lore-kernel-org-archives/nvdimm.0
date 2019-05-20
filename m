Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id EAE4721260505
 for <linux-nvdimm@lists.01.org>; Mon, 20 May 2019 00:03:21 -0700 (PDT)
Date: Mon, 20 May 2019 09:03:17 +0200
From: Michal Hocko <mhocko@kernel.org>
Subject: Re: NULL pointer dereference during memory hotremove
Message-ID: <20190520070317.GU6836@dhcp22.suse.cz>
References: <CA+CK2bBeOJPnnyWBgj0CJ7E1z9GVWVg_EJAmDs07BSJDp3PYfQ@mail.gmail.com>
 <20190517143816.GO6836@dhcp22.suse.cz>
 <CA+CK2bA+2+HaV4GWNUNP04fjjTPKbEGQHSPrSrmY7HLD57au1Q@mail.gmail.com>
 <CA+CK2bDq+2qu28afO__4kzO4=cnLH1P4DcHjc62rt0UtYwLm0A@mail.gmail.com>
 <CA+CK2bCgF7z5UHqrGCYu4JgG=5o6uXbjutTo9VSYAkqu3dqn5w@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CA+CK2bCgF7z5UHqrGCYu4JgG=5o6uXbjutTo9VSYAkqu3dqn5w@mail.gmail.com>
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
To: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: "sashal@kernel.org" <sashal@kernel.org>, "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "Wu," Fengguang" <fengguang.wu@intel.com>, "david@redhat.com, " <david@redhat.com>, tiwai@suse.de" <tiwai@suse.de>, "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "Huang, Ying  <ying.huang@intel.com>, linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "jmorris@namei.org" <jmorris@namei.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "jglisse@redhat.com" <jglisse@redhat.com>, "baiyaowei@cmss.chinamobile.com" <baiyaowei@cmss.chinamobile.com>, "zwisler@kernel.org" <zwisler@kernel.org>, "bhelgaas@google.com" <bhelgaas@google.com>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "bp@suse.de" <bp@suse.de>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri 17-05-19 13:33:25, Pavel Tatashin wrote:
> On Fri, May 17, 2019 at 1:24 PM Pavel Tatashin
> <pasha.tatashin@soleen.com> wrote:
> >
> > On Fri, May 17, 2019 at 1:22 PM Pavel Tatashin
> > <pasha.tatashin@soleen.com> wrote:
> > >
> > > On Fri, May 17, 2019 at 10:38 AM Michal Hocko <mhocko@kernel.org> wrote:
> > > >
> > > > On Fri 17-05-19 10:20:38, Pavel Tatashin wrote:
> > > > > This panic is unrelated to circular lock issue that I reported in a
> > > > > separate thread, that also happens during memory hotremove.
> > > > >
> > > > > xakep ~/x/linux$ git describe
> > > > > v5.1-12317-ga6a4b66bd8f4
> > > >
> > > > Does this happen on 5.0 as well?
> > >
> > > Yes, just reproduced it on 5.0 as well. Unfortunately, I do not have a
> > > script, and have to do it manually, also it does not happen every
> > > time, it happened on 3rd time for me.
> >
> > Actually, sorry, I have not tested 5.0, I compiled 5.0, but my script
> > still tested v5.1-12317-ga6a4b66bd8f4 build. I will report later if I
> > am able to reproduce it on 5.0.
> 
> OK, confirmed on 5.0 as well, took 4 tries to reproduce:

What is the last version that survives? Can you bisect?
-- 
Michal Hocko
SUSE Labs
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
