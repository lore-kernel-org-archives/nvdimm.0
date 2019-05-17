Return-Path: <owner-linux-mm@kvack.org>
Date: Fri, 17 May 2019 16:38:16 +0200
From: Michal Hocko <mhocko@kernel.org>
Subject: Re: NULL pointer dereference during memory hotremove
Message-ID: <20190517143816.GO6836@dhcp22.suse.cz>
References: <CA+CK2bBeOJPnnyWBgj0CJ7E1z9GVWVg_EJAmDs07BSJDp3PYfQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+CK2bBeOJPnnyWBgj0CJ7E1z9GVWVg_EJAmDs07BSJDp3PYfQ@mail.gmail.com>
Sender: owner-linux-mm@kvack.org
To: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: "Verma, Vishal L" <vishal.l.verma@intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "jmorris@namei.org" <jmorris@namei.org>, "tiwai@suse.de" <tiwai@suse.de>, "sashal@kernel.org" <sashal@kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "david@redhat.com" <david@redhat.com>, "bp@suse.de" <bp@suse.de>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "jglisse@redhat.com" <jglisse@redhat.com>, "zwisler@kernel.org" <zwisler@kernel.org>, "Jiang, Dave" <dave.jiang@intel.com>, "bhelgaas@google.com" <bhelgaas@google.com>, "Busch, Keith" <keith.busch@intel.com>, "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "Huang, Ying" <ying.huang@intel.com>, "Wu, Fengguang" <fengguang.wu@intel.com>, "baiyaowei@cmss.chinamobile.com" <baiyaowei@cmss.chinamobile.com>
List-ID: <linux-nvdimm@lists.01.org>

On Fri 17-05-19 10:20:38, Pavel Tatashin wrote:
> This panic is unrelated to circular lock issue that I reported in a
> separate thread, that also happens during memory hotremove.
> 
> xakep ~/x/linux$ git describe
> v5.1-12317-ga6a4b66bd8f4

Does this happen on 5.0 as well?
-- 
Michal Hocko
SUSE Labs
