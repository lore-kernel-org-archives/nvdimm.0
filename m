Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 78D4B2205B926
 for <linux-nvdimm@lists.01.org>; Thu, 11 Jan 2018 08:22:41 -0800 (PST)
Date: Thu, 11 Jan 2018 11:27:45 -0500
From: Jerome Glisse <jglisse@redhat.com>
Subject: Re: revamp vmem_altmap / dev_pagemap handling V3
Message-ID: <20180111162744.GA3279@redhat.com>
References: <20171229075406.1936-1-hch@lst.de> <20180108112646.GA7204@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20180108112646.GA7204@lst.de>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-nvdimm@lists.01.org, x86@kernel.org, linux-kernel@vger.kernel.org, Michal Hocko <mhocko@kernel.org>, linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Jan 08, 2018 at 12:26:46PM +0100, Christoph Hellwig wrote:
> Any chance to get this fully reviewed and picked up before the
> end of the merge window?

Sorry for taking so long to get to that, i looked at all the patches
and did not see anything obviously wrong and i like the cleanup so

Reviewed-by: J=E9r=F4me Glisse <jglisse@redhat.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
