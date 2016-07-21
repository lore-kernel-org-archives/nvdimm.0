From: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Subject: Re: dm stripe: add DAX support
Date: Wed, 20 Jul 2016 21:03:40 -0600
Message-ID: <b5897254-1374-6653-2794-65c310237167@kernel.dk>
References: <1466792610-30369-1-git-send-email-toshi.kani@hpe.com>
 <20160624182859.GD13898@redhat.com> <1468362104.8908.43.camel@hpe.com>
 <20160713020100.GA5872@redhat.com> <1468422189.8908.53.camel@hpe.com>
 <20160721000142.GA21913@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20160721000142.GA21913-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, axboe-b10kYP2dOMg@public.gmane.org
Cc: "linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org" <linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org

On 07/20/2016 06:01 PM, Mike Snitzer wrote:
> On Wed, Jul 13 2016 at 11:03am -0400,
> Kani, Toshimitsu <toshi.kani-ZPxbGqLxI0U@public.gmane.org> wrote:
>
>> On Tue, 2016-07-12 at 22:01 -0400, Mike Snitzer wrote:
>>> On Tue, Jul 12 2016 at  6:22pm -0400,
>>> Kani, Toshimitsu <toshi.kani-ZPxbGqLxI0U@public.gmane.org> wrote:
>>>> On Fri, 2016-06-24 at 14:29 -0400, Mike Snitzer wrote:
>>>>>
>>  :
>>> Thanks for putting this summary together.  Unfortunately none of the DM
>>> changes can be queued for 4.8 until Jens takes the 2 block core patches:
>>> https://patchwork.kernel.org/patch/9196021/
>>> https://patchwork.kernel.org/patch/9196019/
>>>
>>> Not sure what the hold up and/or issue is with them.  But I've asked
>>> twice (and implicilty a 3rd time here).  Hopefully they land in time for
>>> 4.8.
>>
>> Hi Jens,
>>
>> Can you take the two patches above?  These patches add QUEUE_FLAG_DAX and its
>> sysfs show func.  They allow device-mapper to set dax-capability based on its
>> configuration, and also allow user applications to check dax-capability via
>> sysfs.
>
> Hi Jens,
>
> As I shared with you before, here are the 2 patches I staged in
> linux-next via linux-dm.git's 'for-next' (same as in the patchwork
> references above) -- these were staged just so we had linux-next
> coverage until you picked them up.
>
> Please pick these up for 4.8 -- the changes are straightforward, are
> required for DM's DAX support, and Dan Williams has also acked them:
>
> https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=for-next&id=6c00531c6affa42b165df73a1eac3289bc45f4c4
> https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=for-next&id=51d1a5abcd0e88cb4528f35643245ea59cf234f1
>
> Feel free to pick them up from patchwork or cherry-pick from
> linux-dm.git

Added for 4.8, thanks!

-- 
Jens Axboe
