From: "Cheng-mean Liu (SOCCER)" <soccerl-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Subject: RE: [PATCH] nvdimm: Remove minimum size requirement
Date: Mon, 7 Aug 2017 18:09:31 +0000
Message-ID: <MWHPR21MB014312EE257DAA87046C3EA6A6B50@MWHPR21MB0143.namprd21.prod.outlook.com>
References: <20170710183248.2417-1-willy@infradead.org>
 <CAPcyv4ioWUmiHbaGVcpxuK-j0JrcGk-_VcpR6yQtQMUwcRTRcQ@mail.gmail.com>
 <20170710203012.GB22476@bombadil.infradead.org>
 <CAPcyv4h7udHTuf78-_iLid68yMhBqTy9=b7GupJn3ZBLJoAWJA@mail.gmail.com>
 <20170712150401.GA12920@bombadil.infradead.org>
 <CAPcyv4h_=L=F9Gtf9NARH1vV4L0GBtRaUiSjZH-j5OeAdkV5Qg@mail.gmail.com>
 <AD0FC223-2642-42EB-ADF0-A61F5642DEEC@yahoo.com>
 <CAPcyv4jhGSo4RZtiXHKFNwzYwM_YcfoVZx0d4V=iLzdX622rKg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <CAPcyv4jhGSo4RZtiXHKFNwzYwM_YcfoVZx0d4V=iLzdX622rKg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org" <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org

Hi Dan:

   I am wondering if failing on those unittests is still an issue for this minimum size requirement change.

Thanks
Cheng-mean

-----Original Message-----
From: Dan Williams [mailto:dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org] 
Sent: Thursday, July 13, 2017 5:14 PM
To: Socer Liu <soccer_liu-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>
Cc: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>; Cheng-mean Liu (SOCCER) <soccerl-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>; Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>; linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Subject: Re: [PATCH] nvdimm: Remove minimum size requirement

On Wed, Jul 12, 2017 at 10:49 PM, Socer Liu <soccer_liu-/E1597aS9LQAvxtiuMwx3w@public.gmane.org> wrote:
> Thanks great to hear.
>
> Dan,
>    Could you share the patch you ran though the unittests?

That patch is still failing the unit tests, so I have some more work to do to fix the test to understand the new minimum.

> I would like to give the new patch a try in my scenario.

I'll share it when I have the tests running again.
