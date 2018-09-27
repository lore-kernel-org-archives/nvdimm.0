Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id CE20C211350E1
 for <linux-nvdimm@lists.01.org>; Thu, 27 Sep 2018 12:35:36 -0700 (PDT)
Date: Thu, 27 Sep 2018 13:37:45 -0600
From: Keith Busch <keith.busch@linux.intel.com>
Subject: Re: [PATCH 2/3] acpi, nfit: Collect shutdown status
Message-ID: <20180927193745.GH19589@localhost.localdomain>
References: <153802226065.833068.11943510429252969385.stgit@dwillia2-desk3.amr.corp.intel.com>
 <153802227150.833068.16202031710309659911.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <153802227150.833068.16202031710309659911.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-acpi@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Sep 26, 2018 at 09:24:31PM -0700, Dan Williams wrote:
> Some NVDIMMs, in addition to providing an indication of whether the
> previous shutdown was clean, also provide a running count of lifetime
> dirty-shutdown events for the device. In anticipation of this
> functionality appearing on more devices arrange for the nfit driver to
> retrieve / cache this data at DIMM discovery time, and export it via
> sysfs.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Looks good.

Reviewed-by: Keith Busch <keith.busch@intel.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
