Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3E6A1211575ED
 for <linux-nvdimm@lists.01.org>; Wed, 26 Sep 2018 08:45:27 -0700 (PDT)
Subject: Re: [PATCH v5 2/4] mm: Provide kernel parameter to allow disabling
 page init poisoning
References: <20180925200551.3576.18755.stgit@localhost.localdomain>
 <20180925201921.3576.84239.stgit@localhost.localdomain>
 <20180926073831.GC6278@dhcp22.suse.cz>
 <c57da51a-009a-9500-4dc5-1d9912e78abd@linux.intel.com>
From: Dave Hansen <dave.hansen@intel.com>
Message-ID: <98411844-19b7-a75b-d52c-6e2c46b40d57@intel.com>
Date: Wed, 26 Sep 2018 08:41:29 -0700
MIME-Version: 1.0
In-Reply-To: <c57da51a-009a-9500-4dc5-1d9912e78abd@linux.intel.com>
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
To: Alexander Duyck <alexander.h.duyck@linux.intel.com>, Michal Hocko <mhocko@kernel.org>
Cc: pavel.tatashin@microsoft.com, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, mingo@kernel.org, linux-mm@kvack.org, jglisse@redhat.com, rppt@linux.vnet.ibm.com, akpm@linux-foundation.org, kirill.shutemov@linux.intel.com
List-ID: <linux-nvdimm@lists.01.org>

On 09/26/2018 08:24 AM, Alexander Duyck wrote:
> With no options it works just like slub_debug and enables all
> available options. So in our case it is a NOP since we wanted the
> debugging enabled by default.

Yeah, but slub_debug is different.

First, nobody uses the slub_debug=- option because *that* is only used
when you have SLUB_DEBUG=y *and* CONFIG_SLUB_DEBUG_ON=y, which not even
Fedora does.

slub_debug is *primarily* for *adding* debug features.  For this, we
need to turn them off.

It sounds like following slub_debug was a bad idea, especially following
its semantics too closely when it doesn't make sense.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
