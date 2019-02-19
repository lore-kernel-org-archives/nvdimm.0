From: Dexuan Cui <decui-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Subject: RE: [ndctl PATCH] ndctl, monitor: support NVDIMM_FAMILY_HYPERV
Date: Tue, 19 Feb 2019 06:07:37 +0000
Message-ID: <PU1P153MB01693F6D5E6C3D1E6CE6ECF9BF7C0@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
References: <PU1P153MB016948B28D99FE01EE8252DFBF600@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
 <OSAPR01MB3396F103A8B3B5569F26D4DDF7600@OSAPR01MB3396.jpnprd01.prod.outlook.com>
 <PU1P153MB01693A3809BC7EA9B19AC30CBF610@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
 <OSAPR01MB3396721CFC3535CC201B799DF7630@OSAPR01MB3396.jpnprd01.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <OSAPR01MB3396721CFC3535CC201B799DF7630-OxqQCv4d1nQ3UXb08eLJjncolHNk5qUtvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
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
To: "qi.fuli-LMvhtfratI1BDgjK7y7TUQ@public.gmane.org" <qi.fuli-LMvhtfratI1BDgjK7y7TUQ@public.gmane.org>, Dave Jiang <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Vishal Verma <vishal.l.verma-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org" <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Cc: Michael Kelley <mikelley-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org

> From: qi.fuli-LMvhtfratI1BDgjK7y7TUQ@public.gmane.org <qi.fuli-LMvhtfratI1BDgjK7y7TUQ@public.gmane.org>
> Sent: Sunday, February 17, 2019 5:52 PM
> ... 
> I am sorry I didn't explain it clearly enough.
> I want to say that users may not know that NVDIMM_FAMILY_HYPERV doesn't
> support monitoring smart threshold events.
> If users setup monitoring smart threshold events on
> NVDIMM_FAMILY_HYPERV by mistake,
> it would be more friendly to send them a notification.
> 
>  Qi
Got it. 
I'll add an explicit warning and don't monitor unsupported events.

Thanks,
-- Dexuan
