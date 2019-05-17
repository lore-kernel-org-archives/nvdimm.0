Return-Path: <owner-linux-mm@kvack.org>
Subject: Re: NULL pointer dereference during memory hotremove
References: <CA+CK2bBeOJPnnyWBgj0CJ7E1z9GVWVg_EJAmDs07BSJDp3PYfQ@mail.gmail.com>
 <20190517143816.GO6836@dhcp22.suse.cz>
From: David Hildenbrand <david@redhat.com>
Message-ID: <75ae93ee-7897-2ab9-1f15-687ab5b87e72@redhat.com>
Date: Fri, 17 May 2019 16:58:33 +0200
MIME-Version: 1.0
In-Reply-To: <20190517143816.GO6836@dhcp22.suse.cz>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: owner-linux-mm@kvack.org
To: Michal Hocko <mhocko@kernel.org>, Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: "Verma, Vishal L" <vishal.l.verma@intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "jmorris@namei.org" <jmorris@namei.org>, "tiwai@suse.de" <tiwai@suse.de>, "sashal@kernel.org" <sashal@kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "bp@suse.de" <bp@suse.de>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "jglisse@redhat.com" <jglisse@redhat.com>, "zwisler@kernel.org" <zwisler@kernel.org>, "Jiang, Dave" <dave.jiang@intel.com>, "bhelgaas@google.com" <bhelgaas@google.com>, "Busch, Keith" <keith.busch@intel.com>, "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "Huang, Ying" <ying.huang@intel.com>, "Wu, Fengguang" <fengguang.wu@intel.com>, "baiyaowei@cmss.chinamobile.com" <baiyaowei@cmss.chinamobile.com>
List-ID: <linux-nvdimm@lists.01.org>

On 17.05.19 16:38, Michal Hocko wrote:
> On Fri 17-05-19 10:20:38, Pavel Tatashin wrote:
>> This panic is unrelated to circular lock issue that I reported in a
>> separate thread, that also happens during memory hotremove.
>>
>> xakep ~/x/linux$ git describe
>> v5.1-12317-ga6a4b66bd8f4
> 
> Does this happen on 5.0 as well?
> 

We have on the list

[PATCH V3 1/4] mm/hotplug: Reorder arch_remove_memory() call in
__remove_memory()

Can that help?

-- 

Thanks,

David / dhildenb
