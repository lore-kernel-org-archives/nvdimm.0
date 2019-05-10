Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx0a-002e3701.pphosted.com (mx0a-002e3701.pphosted.com
 [148.163.147.86])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 293D521268FAC
 for <linux-nvdimm@lists.01.org>; Fri, 10 May 2019 09:32:41 -0700 (PDT)
From: "Elliott, Robert (Servers)" <elliott@hpe.com>
Subject: RE: [PATCH, RFC 1/2] Add config option to enable FS/DAX PMD sharing
Date: Fri, 10 May 2019 16:32:26 +0000
Message-ID: <AT5PR8401MB116928031D52A318F04A2819AB0C0@AT5PR8401MB1169.NAMPRD84.PROD.OUTLOOK.COM>
References: <1557417933-15701-1-git-send-email-larry.bassel@oracle.com>
 <1557417933-15701-2-git-send-email-larry.bassel@oracle.com>
In-Reply-To: <1557417933-15701-2-git-send-email-larry.bassel@oracle.com>
Content-Language: en-US
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
To: Larry Bassel <larry.bassel@oracle.com>, "mike.kravetz@oracle.com" <mike.kravetz@oracle.com>, "willy@infradead.org" <willy@infradead.org>, "dan.j.williams@intel.com" <dan.j.williams@intel.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>



> -----Original Message-----
> From: Linux-nvdimm <linux-nvdimm-bounces@lists.01.org> On Behalf Of
> Larry Bassel
> Sent: Thursday, May 09, 2019 11:06 AM
> Subject: [PATCH, RFC 1/2] Add config option to enable FS/DAX PMD
> sharing
> 
> If enabled, sharing of FS/DAX PMDs will be attempted.
> 
...
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
...
> 
> +config MAY_SHARE_FSDAX_PMD
> +	def_bool y
> +

Is a config option really necessary - is there any reason to
not choose to do this?



_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
