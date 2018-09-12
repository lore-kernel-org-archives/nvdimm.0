Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id CBBAD2112B1E8
 for <linux-nvdimm@lists.01.org>; Wed, 12 Sep 2018 09:43:28 -0700 (PDT)
Subject: Re: [PATCH 1/4] mm: Provide kernel parameter to allow disabling page
 init poisoning
References: <20180910232615.4068.29155.stgit@localhost.localdomain>
 <20180910234341.4068.26882.stgit@localhost.localdomain>
 <20180912141053.GL10951@dhcp22.suse.cz>
 <CAKgT0UdvhV7U5Zniq=KskXz2QsRP8C7ctr5=ZtJwYAVpBT-RHw@mail.gmail.com>
 <841e8101-40db-9ff2-f688-5f175d91fc31@intel.com>
 <CAKgT0UeKnaY4XebOmtGozbjEJN4k3cwyhdBLPPJLc677-QU+Sw@mail.gmail.com>
From: Dave Hansen <dave.hansen@intel.com>
Message-ID: <68ccf46e-8c1e-c796-df35-afb5b295d6ea@intel.com>
Date: Wed, 12 Sep 2018 09:43:27 -0700
MIME-Version: 1.0
In-Reply-To: <CAKgT0UeKnaY4XebOmtGozbjEJN4k3cwyhdBLPPJLc677-QU+Sw@mail.gmail.com>
Content-Language: en-US
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
To: Alexander Duyck <alexander.duyck@gmail.com>, mhocko@kernel.org, pavel.tatashin@microsoft.com, dan.j.williams@intel.com
Cc: linux-nvdimm@lists.01.org, LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, jglisse@redhat.com, Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On 09/12/2018 09:36 AM, Alexander Duyck wrote:
>>         vm_debug =      [KNL] Available with CONFIG_DEBUG_VM=y.
>>                         May slow down boot speed, especially on larger-
>>                         memory systems when enabled.
>>                         off: turn off all runtime VM debug features
>>                         all: turn on all debug features (default)
> This would introduce a significant amount of code change if we do it
> as a parameter that has control over everything.

Sure, but don't do that now.  Just put page poisoning under it now.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
