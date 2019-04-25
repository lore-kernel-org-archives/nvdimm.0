Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com
 [IPv6:2a00:1450:4864:20::52d])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4F85E209574C6
 for <linux-nvdimm@lists.01.org>; Thu, 25 Apr 2019 11:51:49 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id c1so818198edk.5
 for <linux-nvdimm@lists.01.org>; Thu, 25 Apr 2019 11:51:49 -0700 (PDT)
MIME-Version: 1.0
References: <20190425175440.9354-1-pasha.tatashin@soleen.com>
 <20190425175440.9354-2-pasha.tatashin@soleen.com>
 <67dba1e2-155c-f572-81dd-a6d589d0e8a5@intel.com>
In-Reply-To: <67dba1e2-155c-f572-81dd-a6d589d0e8a5@intel.com>
From: Pavel Tatashin <pasha.tatashin@soleen.com>
Date: Thu, 25 Apr 2019 14:51:37 -0400
Message-ID: <CA+CK2bC5G0DrBpHuaV5xrAAZUKHVwN2N++eiV++SH2gvvbKGHA@mail.gmail.com>
Subject: Re: [v3 1/2] device-dax: fix memory and resource leak if hotplug fails
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
To: Dave Hansen <dave.hansen@intel.com>
Cc: Michal Hocko <mhocko@suse.com>, David Hildenbrand <david@redhat.com>, Takashi Iwai <tiwai@suse.de>, Dave Hansen <dave.hansen@linux.intel.com>, linux-mm <linux-mm@kvack.org>, Yaowei Bai <baiyaowei@cmss.chinamobile.com>, Ross Zwisler <zwisler@kernel.org>, Sasha Levin <sashal@kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, James Morris <jmorris@namei.org>, "Huang, Ying" <ying.huang@intel.com>, Borislav Petkov <bp@suse.de>, Tom Lendacky <thomas.lendacky@amd.com>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Bjorn Helgaas <bhelgaas@google.com>, LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Fengguang Wu <fengguang.wu@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Apr 25, 2019 at 2:32 PM Dave Hansen <dave.hansen@intel.com> wrote:
>
> On 4/25/19 10:54 AM, Pavel Tatashin wrote:
> >       rc = add_memory(numa_node, new_res->start, resource_size(new_res));
> > -     if (rc)
> > +     if (rc) {
> > +             release_resource(new_res);
> > +             kfree(new_res);
> >               return rc;
> > +     }
>
> Looks good to me:
>
> Reviewed-by: Dave Hansen <dave.hansen@intel.com>

Thank you Dave.

Pasha
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
