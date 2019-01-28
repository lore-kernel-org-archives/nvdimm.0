Return-Path: <owner-linux-mm@kvack.org>
Date: Mon, 28 Jan 2019 10:25:49 +0100
From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH 5/5] dax: "Hotplug" persistent memory for use like normal
 RAM
Message-ID: <20190128092549.GF18811@dhcp22.suse.cz>
References: <20190124231441.37A4A305@viggo.jf.intel.com>
 <20190124231448.E102D18E@viggo.jf.intel.com>
 <0852310e-41dc-dc96-2da5-11350f5adce6@oracle.com>
 <CAPcyv4hjJhUQpMy1CVJZur0Ssr7Cr2fkcD50L5gzx6v_KY14vg@mail.gmail.com>
 <5A90DA2E42F8AE43BC4A093BF067884825733A5B@SHSMSX104.ccr.corp.intel.com>
 <CAPcyv4ikXD8rJAmV6tGNiq56m_ZXPZNrYkTwOSUJ7D1O_M5s=w@mail.gmail.com>
 <b7d45d83a314955e7dff25401dfc0d4f4247cfcd.camel@intel.com>
 <dc7d8190-2c94-9bdb-fb5b-a80a3fb55822@oracle.com>
 <CAPcyv4hEyG-1hC=20M7YGFG-BF7yvNcG7EkLurAfysHHB2yXBA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4hEyG-1hC=20M7YGFG-BF7yvNcG7EkLurAfysHHB2yXBA@mail.gmail.com>
Sender: owner-linux-mm@kvack.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Jane Chu <jane.chu@oracle.com>, "Verma, Vishal L" <vishal.l.verma@intel.com>, "Du, Fan" <fan.du@intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "bp@suse.de" <bp@suse.de>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "tiwai@suse.de" <tiwai@suse.de>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "jglisse@redhat.com" <jglisse@redhat.com>, "zwisler@kernel.org" <zwisler@kernel.org>, "baiyaowei@cmss.chinamobile.com" <baiyaowei@cmss.chinamobile.com>, "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "Wu, Fengguang" <fengguang.wu@intel.com>, "Huang, Ying" <ying.huang@intel.com>, "bhelgaas@google.com" <bhelgaas@google.com>
List-ID: <linux-nvdimm@lists.01.org>

On Fri 25-01-19 11:15:08, Dan Williams wrote:
[...]
> However, we should consider this along with the userspace enabling to
> control which device-dax instances are set aside for hotplug. It would
> make sense to have a "clear errors before hotplug" configuration
> option.

I am not sure I understand. Do you mean to clear HWPoison when the
memory is hotadded (add_pages) or onlined (resp. move_pfn_range_to_zone)?
-- 
Michal Hocko
SUSE Labs
