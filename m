Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from NAM01-BY2-obe.outbound.protection.outlook.com
 (mail-by2nam01on0724.outbound.protection.outlook.com
 [IPv6:2a01:111:f400:fe42::724])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9B9ED1A1E2E
 for <linux-nvdimm@lists.01.org>; Wed, 24 Aug 2016 08:22:03 -0700 (PDT)
From: "Kani, Toshimitsu" <toshi.kani@hpe.com>
Subject: Re: [PATCH] memremap: Fix NULL pointer BUG in get_zone_device_page()
Date: Wed, 24 Aug 2016 15:21:46 +0000
Message-ID: <1472052069.1532.13.camel@hpe.com>
References: <1471977800-12688-1-git-send-email-toshi.kani@hpe.com>
 <CAPcyv4g8y4P02wm6Fx5Cx1zX6_xysdYg7jG6jjz6GTX7KqCkvA@mail.gmail.com>
 <1471996023.1532.6.camel@hpe.com>
 <CAPcyv4gJtTj8chX_eTNhs1PJ=D3X7USuDXwFSWSEZt1cUAXpUw@mail.gmail.com>
 <CS1PR84MB0005F40F71804F3988DD23CB82EA0@CS1PR84MB0005.NAMPRD84.PROD.OUTLOOK.COM>
 <CAPcyv4jH+R0vPyMvDhNmrQ-DjvMe_KW9SxPoQCdX8Zbgd3KESA@mail.gmail.com>
 <CAPcyv4g1ULSDXzp5ufpXzp5JB3z1TN_za=_AqUC8E6f2FNsycw@mail.gmail.com>
 <CAPcyv4iuSvx0kYLOaBXP57M-AgStubGg08Td7s_08G=cZTYWdw@mail.gmail.com>
In-Reply-To: <CAPcyv4iuSvx0kYLOaBXP57M-AgStubGg08Td7s_08G=cZTYWdw@mail.gmail.com>
Content-Language: en-US
Content-ID: <DB11963536796048B26AB3A5C70E7FC6@NAMPRD84.PROD.OUTLOOK.COM>
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
To: "dan.j.williams@intel.com" <dan.j.williams@intel.com>
Cc: "ard.biesheuvel@linaro.org" <ard.biesheuvel@linaro.org>, "Mulumudi, Abhilash Kumar  <m.abhilash-kumar@hpe.com>, linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "brian.starkey@arm.com" <brian.starkey@arm.com>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, 2016-08-23 at 22:48 -0700, Dan Williams wrote:
> On Tue, Aug 23, 2016 at 8:58 PM, Dan Williams <dan.j.williams@intel.c
> 
> > 
> > Does the attached patch fix this for you?
> 
> Sorry, should be this much simpler patch that also mirrors what
> driver/nvdimm/pmem.c is doing...

Yes, this change works fine. :-)

Tested-by: Toshi Kani <toshi.kani@hpe.com>

Thanks for the quick fix!
-Toshi
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
