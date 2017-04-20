Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x230.google.com (mail-oi0-x230.google.com
 [IPv6:2607:f8b0:4003:c06::230])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id CBCBA20082EE5
 for <linux-nvdimm@lists.01.org>; Wed, 19 Apr 2017 20:16:25 -0700 (PDT)
Received: by mail-oi0-x230.google.com with SMTP id r203so31700593oib.3
 for <linux-nvdimm@lists.01.org>; Wed, 19 Apr 2017 20:16:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201704201000.drxGPNHB%fengguang.wu@intel.com>
References: <149264111867.36586.15762148888692084363.stgit@dwillia2-desk3.amr.corp.intel.com>
 <201704201000.drxGPNHB%fengguang.wu@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 19 Apr 2017 20:16:24 -0700
Message-ID: <CAPcyv4jWN9-JrckBR1wa1Tp7eqB0Hyb61nUhHak5rotVsTgQ7A@mail.gmail.com>
Subject: Re: [PATCH v3] axon_ram: add dax_operations support
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
To: kbuild test robot <lkp@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-block@vger.kernel.org, dm-devel@redhat.com, kbuild-all@01.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Gerald Schaefer <gerald.schaefer@de.ibm.com>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Apr 19, 2017 at 8:01 PM, kbuild test robot <lkp@intel.com> wrote:
> Hi Dan,
>
> [auto build test ERROR on powerpc/next]
> [also build test ERROR on v4.11-rc7 next-20170419]
> [if your patch is applied to the wrong git tree, please drop us a note to help improve the system]
>
>
> url:    https://github.com/0day-ci/linux/commits/Dan-Williams/axon_ram-add-dax_operations-support/20170420-091615
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/powerpc/linux.git next

Hi kbuild team, yes this is the wrong base. It's part of a larger
series [1] and I'm just re-sending a few select patches with updates
from review, rather than the full 33 patch series. Any better way to
send individual updates to a patch in a series without re-sending the
whole series?

[1]: https://lkml.org/lkml/2017/4/14/495
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
