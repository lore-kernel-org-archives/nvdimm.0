From: Socer Liu <soccer_liu-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] nvdimm: Remove minimum size requirement
Date: Fri, 1 Sep 2017 08:44:33 -0700
Message-ID: <71A90177-9646-4F1C-BAD1-FA1C1B57A798@yahoo.com>
References: <20170710183248.2417-1-willy@infradead.org>
 <CAPcyv4ioWUmiHbaGVcpxuK-j0JrcGk-_VcpR6yQtQMUwcRTRcQ@mail.gmail.com>
 <20170710203012.GB22476@bombadil.infradead.org>
 <CAPcyv4h7udHTuf78-_iLid68yMhBqTy9=b7GupJn3ZBLJoAWJA@mail.gmail.com>
 <20170712150401.GA12920@bombadil.infradead.org>
 <CAPcyv4h_=L=F9Gtf9NARH1vV4L0GBtRaUiSjZH-j5OeAdkV5Qg@mail.gmail.com>
 <AD0FC223-2642-42EB-ADF0-A61F5642DEEC@yahoo.com>
 <CAPcyv4jhGSo4RZtiXHKFNwzYwM_YcfoVZx0d4V=iLzdX622rKg@mail.gmail.com>
 <MWHPR21MB014312EE257DAA87046C3EA6A6B50@MWHPR21MB0143.namprd21.prod.outlook.com>
 <CAPcyv4hsSUBHrYSXGiFN16vjHcPBb3Vng2c+H7g24-TnyWsjkg@mail.gmail.com>
 <CAPcyv4iA1ObGd9miPSOCc=YRziAxWXhC9NSL_TDo97g2t=dp_Q@mail.gmail.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <CAPcyv4iA1ObGd9miPSOCc=YRziAxWXhC9NSL_TDo97g2t=dp_Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
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
Cc: "linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org" <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>, Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Cheng-mean Liu (SOCCER)" <soccerl-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org

Sure, I will look into this.
Thanks for the instructions





> On Aug 31, 2017, at 3:30 PM, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> 
>> On Mon, Aug 7, 2017 at 11:13 AM, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
>> On Mon, Aug 7, 2017 at 11:09 AM, Cheng-mean Liu (SOCCER)
>> <soccerl-0li6OtcxBFHby3iVrkZq2A@public.gmane.org> wrote:
>>> Hi Dan:
>>> 
>>>   I am wondering if failing on those unittests is still an issue for this minimum size requirement change.
>> 
>> Yes, I just haven't had a chance to circle back and get this fixed up.
>> 
>> You can reproduce by running:
>> 
>>    make TESTS=dpa-alloc check
>> 
>> ...in a checkout of the ndctl project: https://github.com/pmem/ndctl
>> 
>> If you attempt that, note the required setup of the nfit_test modules
>> documented in README.md in that same repository.
> 
> I have not had any time to fix up the unit test for this. Soccer, can
> you take a look?
