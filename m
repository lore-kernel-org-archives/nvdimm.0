Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from esa20.fujitsucc.c3s2.iphmx.com (esa20.fujitsucc.c3s2.iphmx.com
 [216.71.158.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D28102119173F
 for <linux-nvdimm@lists.01.org>; Thu, 15 Nov 2018 18:58:25 -0800 (PST)
From: "y-goto@fujitsu.com" <y-goto@fujitsu.com>
Subject: RE: [RFC PATCH 3/3] libnvdimm, MAINTAINERS: Subsystem Profile
Date: Fri, 16 Nov 2018 02:58:16 +0000
Message-ID: <TY2PR01MB32595232F5179F94D5ED203590DD0@TY2PR01MB3259.jpnprd01.prod.outlook.com>
References: <154225759358.2499188.15268218778137905050.stgit@dwillia2-desk3.amr.corp.intel.com>
 <154225761038.2499188.1270468803677883744.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <154225761038.2499188.1270468803677883744.stgit@dwillia2-desk3.amr.corp.intel.com>
Content-Language: ja-JP
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
To: 'Dan Williams' <dan.j.williams@intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "ksummit-discuss@lists.linuxfoundation.org" <ksummit-discuss@lists.linuxfoundation.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "corbet@lwn.net" <corbet@lwn.net>, Ross Zwisler <zwisler@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

Hi, Dan-san,

Thank you for your patch. I have one comment.

> ---
>  Documentation/nvdimm/subsystem-profile.rst |   86 ++++++++++++++++++++++++++++
>  MAINTAINERS                                |    4 +
>  2 files changed, 90 insertions(+)
>  create mode 100644 Documentation/nvdimm/subsystem-profile.rst
> 
> diff --git a/Documentation/nvdimm/subsystem-profile.rst b/Documentation/nvdimm/subsystem-profile.rst
> new file mode 100644
> index 000000000000..d3428be7528e
> --- /dev/null
> +++ b/Documentation/nvdimm/subsystem-profile.rst
> @@ -0,0 +1,86 @@
> +LIBNVDIMM Subsystem Profile
> +===========================
> +
> +Overview
> +--------
> +So, you have recently become a maintainer of the LIBNVDIMM subsystem,
> +condolences, it is a thankless job, here is the lay of the land. The git

Here, I think that more positive sentence is desirable to encourage new comer.

Certainly, I can imagine that maintainer is hard and tough work,
but I believe it is great work.
Even if this is irony or joke, then it may be cause of miss-understanding
(especially, non-native English speaker like me.)

In addition, new coming developer is sometimes nervous 
to post new mail/patch. If this text will be changed for new comer, 
then I think this text will be good to encourage them.
So, I think more positive expression is desirable.

Thanks,

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
