Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from youngberry.canonical.com (youngberry.canonical.com
 [91.189.89.112]) (using TLSv1 with cipher AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C7BD58206F
 for <linux-nvdimm@lists.01.org>; Fri, 16 Dec 2016 05:45:59 -0800 (PST)
From: Colin Ian King <colin.king@canonical.com>
Subject: re: libnvdimm: remove else after return in nsio_rw_bytes()
Message-ID: <12baed38-4682-da16-8572-418bda999268@canonical.com>
Date: Fri, 16 Dec 2016 13:45:19 +0000
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
To: Fabian Frederick <fabf@skynet.be>, Dan Williams <dan.j.williams@intel.com>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Hi there,

While performing some bi-weekly static analysis on linux-next I
discovered a potential -ve sized memcpy in drivers/nvdimm/claim.c in
nsio_rw_bytes() which probably some attention.

CoverityScan found this issue, I think it stems from commit
d37806dc37b42b05515849b0444f09f493cb4cba ("libnvdimm: remove else after
return in nsio_rw_bytes()").

This issue occurs when nvdimm_clear_poison can return a -ve error such
as -ENXIO as follows:

	cleared = nvdimm_clear_poison(&ndns->dev, offset, size);
	if (cleared != size) {
		size = cleared;
		rc = -EIO;
	}

a little later a memcpy_to_pmem() occurs using the -ve size:

	memcpy_to_pmem(nsio->addr + offset, buf, size);

..which doesn't look sane to me.  I'm not sure what the default behavior
should be for this kind of error handling, so I'm drawing this issue to
your attention.

Colin
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
